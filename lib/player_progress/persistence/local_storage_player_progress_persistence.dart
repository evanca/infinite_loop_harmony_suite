import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

import '../../achievements/achievement.dart';
import '../level_progress.dart';
import 'player_progress_persistence.dart';

/// An implementation of [PlayerProgressPersistence] that uses
/// `package:shared_preferences`.
class LocalStoragePlayerProgressPersistence extends PlayerProgressPersistence {
  final Future<SharedPreferences> instanceFuture =
      SharedPreferences.getInstance();

  @override
  Future<Map<int, LevelProgress>> getFinishedLevels() async {
    final prefs = await instanceFuture;
    final String? serializedMap = prefs.getString('levelsFinished');
    if (serializedMap == null) return {1: LevelProgress.initial(1)};

    Map<String, dynamic> decodedMap =
        json.decode(serializedMap) as Map<String, dynamic>;
    Map<int, LevelProgress> levelsFinished = {};

    decodedMap.forEach((key, value) {
      levelsFinished[int.parse(key)] =
          LevelProgress.fromJson(value as Map<String, dynamic>);
    });

    log('Retrieved levels finished: $levelsFinished',
        name: 'LocalStoragePlayerProgressPersistence');

    return levelsFinished;
  }

  @override
  Future<void> saveLevelFinished(LevelProgress levelProgress) async {
    final prefs = await instanceFuture;
    final String serializedMap = prefs.getString('levelsFinished') ?? '{}';

    Map<String, dynamic> levelsFinished =
        json.decode(serializedMap) as Map<String, dynamic>;

    // Check if the level already has saved progress and if the new score is higher
    if (levelsFinished.containsKey(levelProgress.levelNumber.toString())) {
      LevelProgress currentProgress = LevelProgress.fromJson(
          levelsFinished[levelProgress.levelNumber.toString()]
              as Map<String, dynamic>);

      // Only update if the new score is higher
      if (levelProgress.score > currentProgress.score) {
        levelsFinished[levelProgress.levelNumber.toString()] =
            levelProgress.toJson();
      }
    } else {
      // No existing progress for this level, save the new progress
      levelsFinished[levelProgress.levelNumber.toString()] =
          levelProgress.toJson();
    }

    // Save the updated map back to SharedPreferences
    await prefs.setString('levelsFinished', json.encode(levelsFinished));
  }

  @override
  Future<void> saveOverallScore(int score) async {
    final prefs = await instanceFuture;
    await prefs.setInt('overallScore', score);
  }

  @override
  Future<int> getOverallScore() async {
    final prefs = await instanceFuture;
    return prefs.getInt('overallScore') ?? 0;
  }

  @override
  Future<void> saveAchievement(AchievementType achievement) async {
    final prefs = await instanceFuture;
    final String serializedList = prefs.getString('achievements') ?? '[]';

    List<dynamic> achievements = json.decode(serializedList) as List<dynamic>;

    // Add if not already present
    if (!achievements.contains(achievement.toString())) {
      achievements.add(achievement.toString());
    }

    await prefs.setString('achievements', json.encode(achievements));
  }

  @override
  Future<List<AchievementType>> getAchievements() async {
    final prefs = await instanceFuture;
    final String serializedList = prefs.getString('achievements') ?? '[]';

    List<dynamic> achievements = json.decode(serializedList) as List<dynamic>;

    return achievements
        .map((e) => AchievementType.values
            .firstWhere((element) => element.toString() == e))
        .toList();
  }

  @override
  Future<void> reset() async {
    final prefs = await instanceFuture;
    await prefs.remove('levelsFinished');
  }
}
