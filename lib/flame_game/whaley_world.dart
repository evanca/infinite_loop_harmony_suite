import 'dart:developer' as developer;
import 'dart:math';

import 'package:endless_runner/achievements/achievement.dart';
import 'package:endless_runner/achievements/achievement_service.dart';
import 'package:endless_runner/flame_game/constants/trash_items.dart';
import 'package:endless_runner/flame_game/whaley_game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '../bonuses/bonus_service.dart';
import '../constants.dart';
import '../level_selection/level_manager.dart';
import '../player_progress/level_progress.dart';
import '../player_progress/player_progress.dart';
import 'components/bin.dart';
import 'components/bins_image.dart';
import 'components/mood.dart';
import 'components/trash.dart';
import 'game_screen.dart';

class WhaleyWorld extends World
    with TapCallbacks, HasGameReference<WhaleyGame> {
  WhaleyWorld({
    required this.level,
    required this.playerProgress,
    Random? random,
  }) : _random = random ?? Random();

  /// The properties of the current level.
  final GameLevel level;

  /// Used to see what the current progress of the player is and to update the
  /// progress if a level is finished.
  final PlayerProgress playerProgress;

  /// In the [scoreNotifier] we keep track of what the current score is, and if
  /// other parts of the code is interested in when the score is updated they
  /// can listen to it and act on the updated value.
  final scoreNotifier = ValueNotifier(0);

  double moodMeter = 1;

  int correctItems = 0;
  int wrongItems = 0;

  Vector2 get size => Constants.gameSize;

  /// The random number generator that is used to spawn periodic components.
  final Random _random;

  final binColors = TrashItems.byBinColor.keys.toList();

  late LevelProgress levelProgress;

  bool completing = false;

  late final BonusService bonusService;
  late final AchievementService achievementService;

  AchievementType? achievementType;

  (int? lane, double multiplier) highspeedLane = (null, 1);
  Timer? highspeedInterval;
  Timer? highspeedCountdown;

  final countdownNotifier = ValueNotifier(0);

  @override
  Future<void> onLoad() async {
    bonusService = BonusService(this);
    achievementService = AchievementService(this);

    add(BinsImage());

    for (var color in binColors) {
      add(Bin(color));
    }

    // Copy all bin colors for manipulation.
    List<BinColor> availableBinColors = List.of(binColors);

    int id = 0; // Trash item id

    // First row of items before the spawn timer starts.
    availableBinColors.shuffle(_random);
    for (int lane = 0; lane < 5; lane++) {
      BinColor correctBin = availableBinColors.removeLast();
      add(Trash.random(
          id: id++,
          random: _random,
          lane: lane,
          speed: level.speed,
          correctBin: correctBin));
    }

    // Add the rest of items via periodic spawning.
    availableBinColors = List.of(binColors);
    for (int lane = 0; lane < 5; lane++) {
      add(
        SpawnComponent(
          factory: (_) {
            // Stop spawning items when the level is finished.
            if (id >= level.itemCount) {
              developer
                  .log('🥚 Stopping spawn: Reached itemCount with ID: $id');
              return PositionComponent();
            }

            if (id % 5 == 0) {
              // Shuffle bin colors at the start of each new row.
              availableBinColors = List.of(binColors)..shuffle(_random);
            }

            BinColor correctBin = availableBinColors.removeLast();
            return Trash.random(
                id: id++,
                random: _random,
                lane: lane,
                speed: speed(lane),
                correctBin: correctBin);
          },
          period: level.spawnPeriod,
          selfPositioning: true,
          random: _random,
        ),
      );
    }

    add(Mood());
  }

  double speed(lane) =>
      highspeedLane.$1 == lane ? level.speed * highspeedLane.$2 : level.speed;

  @override
  void onMount() {
    super.onMount();
    game.overlays.add(GameScreen.levelHeaderKey);
    highspeedInterval = Timer(
      5,
      onTick: () => _maybeStartHighspeedLane(),
      repeat: true,
    );
  }

  @override
  void onRemove() {
    game.overlays.remove(GameScreen.levelHeaderKey);
    highspeedCountdown = null;
    highspeedInterval = null;
  }

  @override
  void update(double dt) {
    highspeedInterval?.update(dt);
    highspeedCountdown?.update(dt);

    if (highspeedCountdown != null) {
      if (highspeedCountdown!.finished) {
        int lane = _random.nextInt(4);
        highspeedLane = (lane, level.highspeedMultiplier);
        highspeedCountdown = null;
        countdownNotifier.value = 0;
      } else {
        int seconds =
            (highspeedCountdown!.limit - highspeedCountdown!.current).ceil();
        countdownNotifier.value = seconds;
      }
    }
    if (correctItems + wrongItems >= level.itemCount &&
        children.whereType<Trash>().isEmpty) {
      if (!completing) {
        completeLevel();
      }
    }
    super.update(dt);
  }

  Future<void> completeLevel() async {
    completing = true;

    await bonusService.assignLevelBonuses();

    levelProgress = LevelProgress(
        levelNumber: level.number, score: scoreNotifier.value, stars: stars);

    removeWhere((component) => component is Mood);
    game.camera.viewport.removeWhere((component) => component is TextComponent);

    await Future.delayed(const Duration(milliseconds: 100));
    game.pauseEngine();

    playerProgress.setLevelFinished(levelProgress);

    await achievementService.assignAchievements();

    if (stars > 0) {
      game.overlays.add(GameScreen.winDialogKey);
      if (level.number < Constants.lastLevelNumber) {
        playerProgress.maybeUnlockLevel(level.number + 1);
      }
    } else {
      game.overlays.add(GameScreen.loseDialogKey);
    }
  }

  int get stars {
    double correctRatio = correctItems / level.itemCount;
    if (correctRatio > 0.8) {
      return 3;
    } else if (correctRatio > 0.6) {
      return 2;
    } else if (correctRatio > 0.4) {
      return 1;
    } else {
      return 0;
    }
  }

  /// Gives the player points, with a default value +1 points.
  void addScore({int amount = 1}) {
    scoreNotifier.value += amount;
  }

  void updateMoodMeter() {
    double progress = (correctItems + wrongItems) / level.itemCount;
    double correctRatio = correctItems / (correctItems + wrongItems);

    double decayFactor = 0.1; // Give more weight to recent performance
    double recentImpact = correctItems > 0
        ? (1 - decayFactor) * (correctItems / level.itemCount)
        : 0;

    // Calculate performanceIndex with an emphasis on recent performance
    moodMeter = 0.5 + (correctRatio - progress + recentImpact) * 0.5;
  }

  void _maybeStartHighspeedLane() {
    double progress = (correctItems + wrongItems) / level.itemCount;
    int itemsLeft = level.itemCount - (correctItems + wrongItems);
    bool canStartHighspeed =
        progress >= 0.1 && itemsLeft > (level.spawnPeriod * 5);

    if (completing || !canStartHighspeed || highspeedLane.$1 != null) {
      return;
    }

    if (_random.nextDouble() < level.highspeedProbability) {
      highspeedCountdown ??= Timer(3);
    }
  }
}
