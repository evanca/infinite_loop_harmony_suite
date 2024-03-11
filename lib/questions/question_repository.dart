import 'dart:convert';
import 'dart:math';

import 'package:endless_runner/questions/question.dart';
import 'package:flutter/services.dart';

/// A repository class responsible for fetching and providing random questions.
/// It reads questions from a local JSON asset and returns one at random.
class QuestionRepository {
  QuestionRepository({Random? random}) : random = random ?? Random();

  /// The `Random` instance used for generating random indices.
  /// This allows for random selection of a question from the list.
  /// If not provided through the constructor, a default instance is used.
  final Random random;

  /// Fetches a random question from the local JSON asset `questions.json`.
  /// Asynchronously loads and parses the JSON into a list of `Question` objects,
  /// then returns a single `Question` object at a randomly selected index.
  Future<Question> fetchRandomQuestion() async {
    final String response =
        await rootBundle.loadString('assets/json/questions.json');
    final data = json.decode(response) as List<dynamic>;
    final List<Question> questions = data
        .map<Question>(
            (json) => Question.fromJson(json as Map<String, dynamic>))
        .toList();

    final randomIndex = random.nextInt(questions.length);
    return questions[randomIndex];
  }
}
