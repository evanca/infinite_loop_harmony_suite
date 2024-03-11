import 'package:endless_runner/achievements/achievement.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Achievement', () {
    test('whaleBuddy factory constructor sets correct properties', () {
      final achievement = Achievement.whaleBuddy();
      expect(achievement.type, AchievementType.whaleBuddy);
      expect(achievement.title, 'Whale Buddy');
      expect(achievement.description,
          'Cheers to 100 points! Your journey has just begun.');
      expect(achievement.imageUrl,
          'https://raw.githubusercontent.com/evanca/evanca.github.io/default/assets/assets/img/whaley/achievement_blue.png');
    });

    test('oceanGuardian factory constructor sets correct properties', () {
      final achievement = Achievement.oceanGuardian();
      expect(achievement.type, AchievementType.oceanGuardian);
      expect(achievement.title, 'Ocean Guardian');
      expect(achievement.description,
          '1000 points! You\'re making waves in ocean protection.');
      expect(achievement.imageUrl,
          'https://raw.githubusercontent.com/evanca/evanca.github.io/default/assets/assets/img/whaley/achievement_yellow.png');
    });

    test('recyclingHero factory constructor sets correct properties', () {
      final achievement = Achievement.recyclingHero();
      expect(achievement.type, AchievementType.recyclingHero);
      expect(achievement.title, 'Recycling Hero');
      expect(achievement.description,
          '100 levels down! Leading the charge in waste sorting.');
      expect(achievement.imageUrl,
          'https://raw.githubusercontent.com/evanca/evanca.github.io/default/assets/assets/img/whaley/achievement_black.png');
    });

    test('ecoWarrior factory constructor sets correct properties', () {
      final achievement = Achievement.ecoWarrior();
      expect(achievement.type, AchievementType.ecoWarrior);
      expect(achievement.title, 'Eco Warrior');
      expect(achievement.description,
          'A towering 10000 points! Your eco-crusade knows no bounds.');
      expect(achievement.imageUrl,
          'https://raw.githubusercontent.com/evanca/evanca.github.io/default/assets/assets/img/whaley/achievement_green.png');
    });

    test('ultimateChampion factory constructor sets correct properties', () {
      final achievement = Achievement.ultimateChampion();
      expect(achievement.type, AchievementType.ultimateChampion);
      expect(achievement.title, 'Ultimate Champion');
      expect(achievement.description,
          'The crown jewel of achievements! You conquered all 1000 levels.');
      expect(achievement.imageUrl,
          'https://raw.githubusercontent.com/evanca/evanca.github.io/default/assets/assets/img/whaley/achievement_red.png');
    });
  });
}
