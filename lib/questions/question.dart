/// Represents a trivia question with an associated fact, answer, and source URL.
class Question {
  /// A fact related to the question.
  final String fact;

  /// The trivia question text.
  final String question;

  /// The answer to the trivia question.
  final String answer;

  /// The URL to a source where more information about the question's fact can be found.
  final String sourceUrl;

  Question({
    required this.fact,
    required this.question,
    required this.answer,
    required this.sourceUrl,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      fact: json['fact'] as String,
      question: json['question'] as String,
      answer: json['answer'] as String,
      sourceUrl: json['source_url'] as String,
    );
  }

  String get maskedAnswer {
    if (answer.length < 3) {
      return '_' * answer.length;
    }
    // Create a string of underscores of length input.length - 2
    var mask = '_' * (answer.length - 2);
    // Combine the first character, the mask, and the last character
    return answer[0] + mask + answer[answer.length - 1];
  }
}
