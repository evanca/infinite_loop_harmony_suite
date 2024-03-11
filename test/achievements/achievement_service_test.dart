import 'package:endless_runner/achievements/achievement.dart';
import 'package:endless_runner/achievements/achievement_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AchievementService', () {
    test(
        'qualifiesFor returns correct AchievementType based on score and level',
        () {
      expect(
          AchievementService.qualifiesFor(1, 100), AchievementType.whaleBuddy);
      expect(AchievementService.qualifiesFor(1, 1000),
          AchievementType.oceanGuardian);
      expect(AchievementService.qualifiesFor(100, 100),
          AchievementType.recyclingHero);
      expect(AchievementService.qualifiesFor(1, 10000),
          AchievementType.ecoWarrior);
      expect(AchievementService.qualifiesFor(1000, 1000),
          AchievementType.ultimateChampion);
    });
  });
}
