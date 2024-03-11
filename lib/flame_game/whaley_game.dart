import 'package:endless_runner/style/palette.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../audio/audio_controller.dart';
import '../constants.dart';
import '../level_selection/level_manager.dart';
import '../player_progress/player_progress.dart';
import 'whaley_world.dart';

/// This is the base of the game which is added to the [GameWidget].
///
/// This class defines a few different properties for the game:
///  - That it should run collision detection, this is done through the
///  [HasCollisionDetection] mixin.
///  - That it should have a [FixedResolutionViewport] with a size of 1600x720,
///  this means that even if you resize the window, the game itself will keep
///  the defined virtual resolution.
///  - That the default world that the camera is looking at should be the
///  [WhaleyWorld].
///
/// Note that both of the last are passed in to the super constructor, they
/// could also be set inside of `onLoad` for example.
class WhaleyGame extends FlameGame<WhaleyWorld> with HasCollisionDetection {
  WhaleyGame({
    required this.level,
    required PlayerProgress playerProgress,
    required this.audioController,
    required this.isPortrait,
  }) : super(
          world: WhaleyWorld(level: level, playerProgress: playerProgress),
          camera: CameraComponent.withFixedResolution(
              width: isPortrait
                  ? Constants.gameSize.x
                  : Constants.desktopMainAreaSize.x,
              height: isPortrait
                  ? Constants.gameSize.y
                  : Constants.desktopMainAreaSize.y),
        );

  /// What the properties of the level that is played has.
  final GameLevel level;

  /// A helper for playing sound effects and background audio.
  final AudioController audioController;

  /// Whether the game is in portrait mode.
  final bool isPortrait;

  @override
  Color backgroundColor() => Palette.backgroundLevelSelection;

  @override
  bool get debugMode => false;

  /// In the [onLoad] method you load different type of assets and set things
  /// that only needs to be set once when the level starts up.
  @override
  Future<void> onLoad() async {
  }
}
