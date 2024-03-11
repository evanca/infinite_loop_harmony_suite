import '../../achievements/achievement.dart';
import '../level_progress.dart';

/// An interface of persistence stores for the player's progress.
///
/// Implementations can range from simple in-memory storage through
/// local preferences to cloud saves.
abstract class PlayerProgressPersistence {
  Future<Map<int, LevelProgress>> getFinishedLevels();

  Future<void> saveLevelFinished(LevelProgress levelProgress);

  Future<void> saveOverallScore(int score);

  Future<int> getOverallScore();

  Future<void> saveAchievement(AchievementType achievement);

  Future<List<AchievementType>> getAchievements();

  Future<void> reset();
}
