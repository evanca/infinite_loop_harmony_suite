import 'package:endless_runner/constants.dart';
import 'package:endless_runner/extensions.dart';
import 'package:endless_runner/flame_game/whaley_game.dart';
import 'package:endless_runner/flame_game/whaley_world.dart';
import 'package:endless_runner/gen/assets.gen.dart';
import 'package:flame/components.dart';

/// The [BinsImage] is the component that renders the bins image at the bottom
/// of the screen. This element is not interactive and is only used for UI.
class BinsImage extends PositionComponent
    with HasGameReference<WhaleyGame>, HasWorldReference<WhaleyWorld> {
  @override
  Future<void> onLoad() async {
    final width = world.size.x;
    final height = width / Constants.binsImageSize;

    await add(
      SpriteComponent(
        sprite: await Sprite.load(
          Assets.images.bins.getFilename(),
        ),
        size: Vector2(width.toDouble(), height.toDouble()),
      ),
    );

    final positionX = -(world.size.x / 2); // Left edge of the game area
    final positionY =
        (world.size.y / 2) - height; // Bottom edge of the game area

    position = Vector2(positionX.toDouble(), positionY.toDouble());
  }
}
