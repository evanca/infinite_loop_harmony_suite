import 'dart:developer';
import 'dart:math' as math;

import 'package:endless_runner/constants.dart';

class GameLevel {
  final int number;
  final int itemCount;
  final double speed;
  final double spawnPeriod;
  final double highspeedProbability;
  final double highspeedMultiplier;

  GameLevel({
    required this.number,
    required this.itemCount,
    required this.speed,
    required this.spawnPeriod,
    required this.highspeedProbability,
    required this.highspeedMultiplier,
  });
}

class LevelManager {
  static const _initialSpeed = 100; // Revert to 100 after testing
  static const _maxSpeed = 1000; // Revert to 1000 after testing

  static const _initialItemCount = 25;
  static const _maxItemCount = 1000;

  static const _initialHighspeedMultiplier = 1.5;
  static const _maxHighspeedMultiplier = 2.0;

  static const _minHighspeedProbability = 0.5;
  static const _maxHighspeedProbability = 1;

  GameLevel generateLevel(int levelNumber) {
    final interpolatedItemCount = _calculateItemCount(levelNumber);
    // Round itemCount to the nearest multiple of 5.
    int itemCount = (interpolatedItemCount / 5).round() * 5;

    double speed = _calculateSpeed(levelNumber);

    // Calculate the speed factor relative to level 1
    double speedFactor = speed / _initialSpeed;

    // Adjust the spawn period inversely proportional to the speed factor
    // This ensures items spawn closer together as speed increases
    double spawnPeriod = 3 / speedFactor;

    log('Level $levelNumber has $itemCount trash items and a speed of $speed,'
        ' spawnPeriod of $spawnPeriod');

    return GameLevel(
      number: levelNumber,
      itemCount: itemCount,
      speed: speed,
      spawnPeriod: spawnPeriod,
      highspeedProbability: _randomHighspeedProbability(),
      highspeedMultiplier: _calculateHighspeedMultiplier(levelNumber),
    );
  }

  static double _calculateSpeed(int levelNumber) {
    return _initialSpeed +
        (levelNumber - 1) *
            (_maxSpeed - _initialSpeed) /
            (Constants.lastLevelNumber - 1);
  }

  static double _calculateItemCount(int levelNumber) {
    return _initialItemCount +
        (levelNumber - 1) *
            (_maxItemCount - _initialItemCount) /
            (Constants.lastLevelNumber - 1);
  }

  static double _randomHighspeedProbability() {
    final random = math.Random();
    return _minHighspeedProbability +
        random.nextDouble() *
            (_maxHighspeedProbability - _minHighspeedProbability);
  }

  static double _calculateHighspeedMultiplier(int levelNumber) {
    return _initialHighspeedMultiplier +
        (levelNumber - 1) *
            (_maxHighspeedMultiplier - _initialHighspeedMultiplier) /
            (Constants.lastLevelNumber - 1);
  }
}
