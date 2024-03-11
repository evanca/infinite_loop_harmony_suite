import 'dart:developer' as developer;
import 'dart:math';

import 'package:endless_runner/extensions.dart';
import 'package:endless_runner/flame_game/constants/trash_items.dart';
import 'package:endless_runner/flame_game/whaley_game.dart';
import 'package:endless_runner/flame_game/whaley_world.dart';
import 'package:endless_runner/gen/assets.gen.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/geometry.dart';

import '../../constants.dart';
import 'bin.dart';

class Trash extends PositionComponent
    with
        HasGameReference<WhaleyGame>,
        HasWorldReference<WhaleyWorld>,
        DragCallbacks,
        CollisionCallbacks {
  Trash({
    required this.id,
    required this.image,
    required this.random,
    required this.lane,
    required this.speed,
  });

  final int id;
  final AssetGenImage image;
  final Random random;
  final double speed;
  late int lane;

  late final double laneWidth;
  final Vector2 velocity = Vector2.zero();

  bool dragging = false;
  Trash? collidable;

  final enlarge = ScaleEffect.by(
    Vector2.all(1.15),
    EffectController(duration: 0.1),
  );

  final shrink = ScaleEffect.by(
    Vector2.all(0.85),
    EffectController(duration: 0.1),
  );

  final rotateRight = RotateEffect.by(
    tau / 12,
    EffectController(duration: 0.1),
  );

  final rotateLeft = RotateEffect.by(
    -tau / 6,
    EffectController(duration: 0.1),
  );

  late final SequenceEffect effect;

  @override
  void update(double dt) {
    velocity.y = speed;
    position += velocity * dt;
    super.update(dt);
  }

  @override
  Future<void> onLoad() async {
    final List<Effect> effects = [enlarge, rotateRight, shrink, rotateLeft];
    effects.shuffle();
    effect = SequenceEffect(effects);

    laneWidth = world.size.x / 5;

    await add(SpriteComponent(
      sprite: await Sprite.load(image.getFilename()),
      scale: Vector2.all(1.65),
    ));

    add(CircleHitbox());

    // Used in containsLocalPoint() for drag detection:
    size = Vector2.all(laneWidth * 0.75);

    position =
        Vector2(getXPosition(lane, laneWidth), 0 - game.canvasSize.y / 2);

    anchor = Anchor.center;

    debugColor = correctBinColor.colorValue;
    developer
        .log('Trash [$id] loaded with image [${toString()}] in lane [$lane]');
  }

  double getXPosition(int lane, double laneWidth) {
    return (lane - 2) * laneWidth;
  }

  int getLaneNumber(double xPosition, double laneWidth) {
    double centerX = xPosition + (Constants.gameSize.x / 2);
    int laneNumber = (centerX / laneWidth).floor();

    laneNumber = max(0, min(laneNumber, 5 - 1));

    return laneNumber;
  }

  BinColor get correctBinColor => switch (image.path) {
        (String path) when path.contains('red_') => BinColor.red,
        (String path) when path.contains('yellow_') => BinColor.yellow,
        (String path) when path.contains('green_') => BinColor.green,
        (String path) when path.contains('blue_') => BinColor.blue,
        (_) => BinColor.black,
      };

  factory Trash.random({
    required int id,
    required Random random,
    required int lane,
    required double speed,
    required BinColor correctBin,
  }) {
    final index = random.nextInt(TrashItems.byBinColor[correctBin]!.length);
    final image = TrashItems.byBinColor[correctBin]![index];
    developer.log('Creating random trash with id: $id and speed: $speed');
    return Trash(
      id: id,
      image: image,
      random: random,
      lane: lane,
      speed: speed,
    );
  }

  @override
  bool containsLocalPoint(Vector2 point) {
    final sensitiveArea = RectangleComponent(
      size: Vector2(laneWidth * 0.99, height * 2),
    );

    final whenDraggingSensitiveArea = RectangleComponent(
      size: Vector2(laneWidth * 2, game.size.y),
    );

    return dragging
        ? whenDraggingSensitiveArea.containsLocalPoint(point)
        : sensitiveArea.containsLocalPoint(point);
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    dragging = true;
    priority = 10;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    double positionX = position.x + event.localDelta.x;
    position.x = positionX.clamp(-world.size.x / 2, world.size.x / 2);
    if (position.x != positionX) {
      developer.log('🚫 Dragging outside of the game area');
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    dragging = false;
    priority = 0;

    // Handle empty slot, no collidable:
    if (collidable == null) {
      int newLane = getLaneNumber(position.x, laneWidth);
      moveToLane(newLane);
    } else if (collidable?.correctBinColor == correctBinColor) {
      // Allow two items in a slot if they have the same correct bin color:
      moveToLane(collidable!.lane);
    } else {
      final int currentLane = collidable?.lane ?? lane;
      collidable?.moveToLane(lane);
      moveToLane(currentLane);
    }
    developer.log('Dragging ended with a collidable set to [$collidable], my '
        'new lane is [$lane] and collidable is in [${collidable?.lane}]');
    super.onDragEnd(event);
  }

  void moveToLane(int lane) {
    position.x = getXPosition(lane, laneWidth);
    this.lane = lane;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Trash && dragging) {
      // developer.log('▶️ I am [${toString()}] colliding with [$other]');
      collidable = other;
    } else if (other is Bin) {
      add(effect);
    }
    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (dragging) {
      developer
          .log('⏹️ I am [${toString()}] no longer colliding with [$other]');
    }
    if (collidable == other) {
      collidable = null;
    }
    super.onCollisionEnd(other);
  }

  @override
  toString() => image.path.split('_').last.replaceAll('.png', '');

  @override
  bool operator ==(Object other) =>
      other is Trash && other.id == id && other.image == image;

  @override
  int get hashCode => id.hashCode ^ image.hashCode;
}
