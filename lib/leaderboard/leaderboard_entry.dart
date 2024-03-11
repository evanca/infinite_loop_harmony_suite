import '../achievements/achievement.dart';

class LeaderboardEntry {
  final String userId;
  final String name;
  final int overallScore;
  final List<AchievementType> achievements;

  LeaderboardEntry({
    required this.userId,
    required this.name,
    required this.overallScore,
    required this.achievements,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'overallScore': overallScore,
      'achievements': achievements.map((e) => e.name).toList(),
    };
  }

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      userId: json['userId'] as String,
      name: json['name'] as String,
      overallScore: json['overallScore'] as int,
      achievements: (json['achievements'] as List)
          .map((e) =>
              AchievementType.values.firstWhere((element) => element.name == e))
          .toList(),
    );
  }
}
