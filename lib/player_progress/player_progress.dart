import 'dart:async';
import 'dart:developer';

import 'package:endless_runner/achievements/achievement.dart';
import 'package:endless_runner/constants.dart';
import 'package:endless_runner/leaderboard/persistence/cloud_leaderboard_persistence.dart';
import 'package:endless_runner/leaderboard/persistence/leaderboard_persistence.dart';
import 'package:flutter/foundation.dart';

import '../leaderboard/leaderboard_entry.dart';
import '../settings/settings.dart';
import 'level_progress.dart';
import 'persistence/local_storage_player_progress_persistence.dart';
import 'persistence/player_progress_persistence.dart';

/// Encapsulates the player's progress.
class PlayerProgress extends ChangeNotifier {
  PlayerProgress(
      {PlayerProgressPersistence? store,
      LeaderboardPersistence? leaderboardPersistence})
      : _store = store ?? LocalStoragePlayerProgressPersistence(),
        _leaderboardPersistence =
            leaderboardPersistence ?? CloudLeaderboardPersistence() {
    getLatestFromStore();
  }

  final PlayerProgressPersistence _store;
  final SettingsController _settingsController = SettingsController();
  final LeaderboardPersistence _leaderboardPersistence;

  Map<int, LevelProgress> _levelsFinished = {1: LevelProgress.initial(1)};

  /// The scores for the levels that the player has finished so far.
  Map<int, LevelProgress> get levels => _levelsFinished;

  int get highestLevelFinished => _levelsFinished.keys
      .reduce((value, element) => value > element ? value : element);

  int get overallScore => _levelsFinished.values
      .map((progress) => progress.score)
      .fold(0, (a, b) => a + b);

  final List<AchievementType> _collectedAchievements = [];

  List<AchievementType> get achievements => _collectedAchievements;

  /// Fetches the latest data from the backing persistence store.
  Future<void> getLatestFromStore() async {
    final levelsFinished = await _store.getFinishedLevels();
    _levelsFinished = levelsFinished;
    _collectedAchievements.addAll(await _store.getAchievements());
    notifyListeners();
  }

  /// Resets the player's progress so it's like if they just started
  /// playing the game for the first time.
  void reset() {
    _store.reset();
    _levelsFinished = {1: LevelProgress.initial(1)};
    notifyListeners();
  }

  /// Updates or adds progress for a level based on the new score and stars.
  /// If the level is previously finished and the new score is higher, or it's
  /// a new completion, the progress is updated or added respectively. Notifies
  /// listeners and saves the progress.
  void setLevelFinished(LevelProgress progress) {
    final levelNumber = progress.levelNumber;

    // Check if the level already has saved progress and if the new score is higher
    if (_levelsFinished.containsKey(levelNumber)) {
      final currentProgress = _levelsFinished[levelNumber]!;
      // Only update if the new score is higher
      if (progress.score > currentProgress.score) {
        _levelsFinished[levelNumber] = progress;
      }
    } else {
      // No existing progress for this level, save the new progress
      _levelsFinished[levelNumber] = progress;
    }

    notifyListeners();
    _saveOverallScoreToLeaderboard();

    unawaited(_store.saveLevelFinished(progress));
  }

  void maybeUnlockLevel(int levelNumber) {
    log('Unlocking level $levelNumber');
    if (levelNumber > Constants.lastLevelNumber) {
      throw ArgumentError(
          'Level number $levelNumber is higher than the max level');
    }
    if (_levelsFinished.containsKey(levelNumber) || levelNumber == 1) {
      return;
    }
    _levelsFinished[levelNumber] ??= LevelProgress.initial(levelNumber);
    notifyListeners();
    unawaited(_store.saveLevelFinished(LevelProgress.initial(levelNumber)));
  }

  void collectAchievement(AchievementType achievement) {
    log('Collecting achievement $achievement');
    _collectedAchievements.add(achievement);
    notifyListeners();
    unawaited(_store.saveAchievement(achievement));
  }

  void _saveOverallScoreToLeaderboard() {
    log('Overall score: $overallScore');

    final userId = _settingsController.userId;
    final name = _settingsController.playerName.value;

    if (userId == null) {
      log('No user ID, not saving to leaderboard');
      return;
    }

    final entry = LeaderboardEntry(
      userId: userId,
      name: name,
      overallScore: overallScore,
      achievements: _collectedAchievements,
    );

    unawaited(_store.saveOverallScore(overallScore));
    unawaited(_leaderboardPersistence.saveLeaderboardEntry(entry));
  }
}
