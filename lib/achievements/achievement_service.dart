import 'dart:developer';

import 'package:endless_runner/achievements/achievement.dart';

import '../flame_game/game_screen.dart';
import '../flame_game/whaley_world.dart';

/// Manages and assigns game achievements based on player progress within the Whaley World.
///
/// This service evaluates player progress, such as levels completed and scores achieved,
/// to award achievements. It ensures achievements are only awarded once and handles
/// displaying the achievement notification overlay.
class AchievementService {
  final WhaleyWorld _world;

  AchievementService(WhaleyWorld? world) : _world = world!;

  /// Evaluates and assigns new achievements to the player based on current game progress.
  ///
  /// It checks the player's highest completed level and overall score against set criteria
  /// to determine eligibility for achievements. Achievements already collected are skipped
  /// to avoid duplication. Triggers an overlay to notify the player of newly earned achievements.
  Future<void> assignAchievements() async {
    _world.achievementType = null;

    final achievementType = AchievementService.qualifiesFor(
        _world.playerProgress.highestLevelFinished,
        _world.playerProgress.overallScore);

    if (achievementType != null) {
      log('Player qualifies for achievement: $achievementType');
      // Prevent re-awarding already collected achievements
      if (_world.playerProgress.achievements.contains(achievementType)) {
        log('Player has already collected this achievement: $achievementType');
        return;
      }

      _world.playerProgress.collectAchievement(achievementType);
      _world.achievementType = achievementType;
      _world.game.overlays.add(GameScreen.achievementDialogKey);
    }

    // Waits for the achievement dialog to be dismissed before proceeding
    await Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 100));
      return _world.game.overlays.activeOverlays
          .contains(GameScreen.achievementDialogKey);
    }).timeout(const Duration(seconds: 20), onTimeout: () {
      // Removes the achievement dialog if it's not dismissed after a timeout
      _world.game.overlays.remove(GameScreen.achievementDialogKey);
    });
  }

  /// Determines if a player qualifies for an achievement based on their level completion and score.
  ///
  /// Returns the `AchievementType` the player qualifies for, if any, based on the
  /// criteria of finished levels and overall score. Returns `null` if no achievements
  /// are met.
  static AchievementType? qualifiesFor(int finishedLevel, int overallScore) {
    if (finishedLevel == 1000) {
      return AchievementType.ultimateChampion;
    } else if (finishedLevel >= 100) {
      return AchievementType.recyclingHero;
    } else if (overallScore >= 10000) {
      return AchievementType.ecoWarrior;
    } else if (overallScore >= 1000) {
      return AchievementType.oceanGuardian;
    } else if (overallScore >= 100) {
      return AchievementType.whaleBuddy;
    }
    return null;
  }
}
