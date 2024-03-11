import 'package:endless_runner/constants.dart';
import 'package:endless_runner/flame_game/components/trash.dart';
import 'package:endless_runner/flame_game/whaley_game.dart';
import 'package:endless_runner/flame_game/whaley_world.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// The color corresponding to the bin image.
enum BinColor {
  red(Colors.red),
  yellow(Colors.yellow),
  green(Colors.green),
  blue(Colors.blue),
  black(Colors.black);

  final Color colorValue;

  const BinColor(this.colorValue);
}

/// Represents a bin in the game, distinguished by its color. The bin's position and size are calculated
/// based on the world's dimensions and the index of its color in `BinColor.values`. It supports collision
/// detection with the addition of a `RectangleHitbox`.
class Bin extends RectangleComponent
    with
        HasGameReference<WhaleyGame>,
        HasWorldReference<WhaleyWorld>,
        CollisionCallbacks {
  final BinColor color;

  Bin(this.color);

  @override
  Future<void> onLoad() async {
    final width = world.size.x / 5;
    final height = width / Constants.binsImageSize * 5;

    int index = BinColor.values.indexOf(color);

    final size = Vector2(width.toDouble(), height.toDouble());

    await add(
      RectangleComponent(
        size: size,
        paint: Paint()
          ..color = game.debugMode
              ? color.colorValue.withOpacity(0.75)
              : Colors.transparent,
      ),
    );

    final positionX = index * width - (world.size.x / 2);
    final positionY =
        (world.size.y / 2) - height; // Bottom edge of the game area

    position = Vector2(positionX.toDouble(), positionY.toDouble());

    add(RectangleHitbox.relative(Vector2(0.99, 1), parentSize: size));
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    Future.delayed(const Duration(milliseconds: 500))
        .then((value) => {other.removeFromParent()});

    if (other is Trash && other.correctBinColor == color) {
      world.correctItems++;
      world.addScore();
      if (world.highspeedLane.$1 != 1) {
        world.bonusService.highspeedCorrectItems++;
      }
    } else if (other is Trash) {
      world.wrongItems++;
      if (world.highspeedLane.$1 != 1) {
        world.bonusService.highspeedWrongItems++;
      }
    }
    if (world.highspeedLane.$1 == null) {
      // Full rows work only when highspeed is not active
      world.bonusService.checkForFinishedRow();
    }
    world.updateMoodMeter();
  }
}
