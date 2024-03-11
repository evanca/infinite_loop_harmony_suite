import 'package:endless_runner/constants.dart';
import 'package:endless_runner/extensions.dart';
import 'package:endless_runner/flame_game/whaley_game.dart';
import 'package:endless_runner/flame_game/whaley_world.dart';
import 'package:endless_runner/gen/assets.gen.dart';
import 'package:flame/components.dart';

import '../../audio/sounds.dart';

enum MoodState { happy, neutral, sad }

class Mood extends SpriteGroupComponent<MoodState>
    with HasGameReference<WhaleyGame>, HasWorldReference<WhaleyWorld> {
  @override
  Future<void> onLoad() async {
    final sadSprite = await Sprite.load(
      Assets.images.whaleySad.getFilename(),
    );
    final neutralSprite = await Sprite.load(
      Assets.images.whaleyNeutral.getFilename(),
    );
    final happySprite = await Sprite.load(
      Assets.images.whaleyHappy.getFilename(),
    );

    sprites = {
      MoodState.happy: happySprite,
      MoodState.neutral: neutralSprite,
      MoodState.sad: sadSprite,
    };

    current = MoodState.happy;

    final width = world.size.x / 4;
    final height = width * Constants.moodImageSize;

    size = Vector2(width, height);

    position = Vector2(game.size.x / 2 - size.x - (game.isPortrait ? 10 : 0),
        -world.size.y / 2 + 10);
    priority = 1;
  }

  @override
  Future<void> update(double dt) async {
    MoodState? previous = current;
    if (world.moodMeter >= 0.75) {
      current = MoodState.happy;
    } else if (world.moodMeter >= 0.5) {
      current = MoodState.neutral;
    } else {
      current = MoodState.sad;
      if (previous != MoodState.sad) {
        game.audioController.playSfx(SfxType.ohNo);
      }
    }
    super.update(dt);
  }
}
