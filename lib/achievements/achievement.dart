import '../gen/assets.gen.dart';

/// Defines the set of achievements players can earn in the game.
enum AchievementType {
  whaleBuddy('Whale Buddy'),
  oceanGuardian('Ocean Guardian'),
  recyclingHero('Recycling Hero'),
  ecoWarrior('Eco Warrior'),
  ultimateChampion('Ultimate Champion');

  final String title;

  const AchievementType(this.title);
}

/// Represents an achievement in the game, showcasing a player's milestone.
///
/// This class encapsulates details about specific achievements players can earn,
/// including the type of achievement, its title, a descriptive text, and an
/// associated image URL. Factory constructors for each achievement type provide
/// a convenient way to create instances representing each significant milestone,
/// such as reaching a certain score or completing a set number of levels.
class Achievement {
  final AchievementType type;
  final String title;
  final String description;
  final String imageUrl;

  const Achievement({
    required this.type,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  factory Achievement.whaleBuddy() {
    return Achievement(
      type: AchievementType.whaleBuddy,
      title: AchievementType.whaleBuddy.title,
      description: 'Cheers to 100 points! Your journey has just begun.',
      imageUrl:
          'https://raw.githubusercontent.com/evanca/evanca.github.io/default/assets/assets/img/whaley/achievement_blue.png',
    );
  }

  factory Achievement.oceanGuardian() {
    return Achievement(
      type: AchievementType.oceanGuardian,
      title: AchievementType.oceanGuardian.title,
      description: '1000 points! You\'re making waves in ocean protection.',
      imageUrl:
          'https://raw.githubusercontent.com/evanca/evanca.github.io/default/assets/assets/img/whaley/achievement_yellow.png',
    );
  }

  factory Achievement.recyclingHero() {
    return Achievement(
      type: AchievementType.recyclingHero,
      title: AchievementType.recyclingHero.title,
      description: '100 levels down! Leading the charge in waste sorting.',
      imageUrl:
          'https://raw.githubusercontent.com/evanca/evanca.github.io/default/assets/assets/img/whaley/achievement_black.png',
    );
  }

  factory Achievement.ecoWarrior() {
    return Achievement(
      type: AchievementType.ecoWarrior,
      title: AchievementType.ecoWarrior.title,
      description: 'A towering 10000 points! Your eco-crusade knows no bounds.',
      imageUrl:
          'https://raw.githubusercontent.com/evanca/evanca.github.io/default/assets/assets/img/whaley/achievement_green.png',
    );
  }

  factory Achievement.ultimateChampion() {
    return Achievement(
      type: AchievementType.ultimateChampion,
      title: AchievementType.ultimateChampion.title,
      description: 'The crown jewel of achievements! You conquered all 1000 '
          'levels.',
      imageUrl:
          'https://raw.githubusercontent.com/evanca/evanca.github.io/default/assets/assets/img/whaley/achievement_red.png',
    );
  }

  AssetGenImage get image {
    return switch (type) {
      AchievementType.whaleBuddy => Assets.images.whaleBuddy,
      AchievementType.oceanGuardian => Assets.images.oceanGuardian,
      AchievementType.recyclingHero => Assets.images.recyclingHero,
      AchievementType.ecoWarrior => Assets.images.ecoWarrior,
      AchievementType.ultimateChampion => Assets.images.ultimateChampion,
    };
  }

  static Achievement byType(AchievementType achievementType) {
    return switch (achievementType) {
      AchievementType.whaleBuddy => Achievement.whaleBuddy(),
      AchievementType.oceanGuardian => Achievement.oceanGuardian(),
      AchievementType.recyclingHero => Achievement.recyclingHero(),
      AchievementType.ecoWarrior => Achievement.ecoWarrior(),
      AchievementType.ultimateChampion => Achievement.ultimateChampion(),
    };
  }
}
