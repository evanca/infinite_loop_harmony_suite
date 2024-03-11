/// Represents the progress made by a player on a specific game level.
///
/// This model captures the level number, score achieved, and stars awarded
/// to the player, providing a structured way to track and manage player
/// achievements across different levels of the game.
///
/// It includes methods for JSON serialization and deserialization, allowing
/// for easy storage and retrieval from persistent storage solutions.
///
/// Additionally, an `initial` factory constructor is provided for creating
/// initial progress instances with default values for score and stars.
class LevelProgress {
  final int levelNumber;
  final int score;
  final int stars;

  LevelProgress({
    required this.levelNumber,
    required this.score,
    required this.stars,
  });

  Map<String, dynamic> toJson() => {
        'levelNumber': levelNumber,
        'score': score,
        'stars': stars,
      };

  factory LevelProgress.fromJson(Map<String, dynamic> json) {
    return LevelProgress(
      levelNumber: json['levelNumber'] as int,
      score: json['score'] as int,
      stars: json['stars'] as int,
    );
  }

  factory LevelProgress.initial(int levelNumber) {
    return LevelProgress(levelNumber: levelNumber, score: 0, stars: 0);
  }
}
