import 'dart:core';

import '../../achievements/achievement.dart';
import '../level_progress.dart';
import 'player_progress_persistence.dart';

/// An in-memory implementation of [PlayerProgressPersistence].
/// Useful for testing.
class MemoryOnlyPlayerProgressPersistence implements PlayerProgressPersistence {
  final levels = <int, LevelProgress>{};

  @override
  Future<Map<int, LevelProgress>> getFinishedLevels() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return levels;
  }

  @override
  Future<void> saveLevelFinished(LevelProgress levelProgress) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    levels[levelProgress.levelNumber] = levelProgress;
  }

  @override
  Future<void> saveOverallScore(int score) async {
    return;
  }

  @override
  Future<int> getOverallScore() async {
    return 0;
  }

  @override
  Future<void> saveAchievement(AchievementType achievement) async {
    return;
  }

  @override
  Future<List<AchievementType>> getAchievements() async {
    return [];
  }

  @override
  Future<void> reset() async {
    levels.clear();
  }
}
