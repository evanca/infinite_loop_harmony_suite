import 'package:endless_runner/achievements/achievement_overlay.dart';
import 'package:endless_runner/flame_game/end_level_dialogs/level_lose_dialog.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../bonuses/bonus_overlay.dart';
import '../level_selection/level_manager.dart';
import '../player_progress/player_progress.dart';
import 'end_level_dialogs/level_win_dialog.dart';
import 'level_header_overlay.dart';
import 'whaley_game.dart';

/// This widget defines the properties of the game screen.
///
/// It mostly sets up the overlays (widgets shown on top of the Flame game) and
/// the gets the [AudioController] from the context and passes it in to the
/// [WhaleyGame] class so that it can play audio.
class GameScreen extends StatelessWidget {
  const GameScreen({required this.level, super.key});

  final GameLevel level;

  static const String winDialogKey = 'win_dialog';
  static const String loseDialogKey = 'lose_dialog';
  static const String achievementDialogKey = 'achievement_dialog';
  static const String levelHeaderKey = 'level_header';

  @override
  Widget build(BuildContext context) {
    final audioController = context.read<AudioController>();
    return Scaffold(
      body: Semantics(
        label: 'Game field',
        child: GameWidget<WhaleyGame>(
          key: const Key('play session'),
          game: WhaleyGame(
            level: level,
            playerProgress: context.read<PlayerProgress>(),
            audioController: audioController,
            isPortrait: MediaQuery.sizeOf(context).height >
                MediaQuery.sizeOf(context).width,
          ),
          overlayBuilderMap: {
            levelHeaderKey: (BuildContext context, WhaleyGame game) {
              return LevelHeaderOverlay(
                game: game,
              );
            },
            winDialogKey: (BuildContext context, WhaleyGame game) {
              return LevelWinDialog(
                levelProgress: game.world.levelProgress,
              );
            },
            loseDialogKey: (BuildContext context, WhaleyGame game) {
              return LevelLoseDialog(levelProgress: game.world.levelProgress);
            },
            BonusType.fullRow.name: (BuildContext context, WhaleyGame game) {
              return BonusOverlay(
                  bonusType: BonusType.fullRow,
                  count: game.world.bonusService.bonuses[BonusType.fullRow]!);
            },
            BonusType.fiveRows.name: (BuildContext context, WhaleyGame game) {
              return BonusOverlay(
                  bonusType: BonusType.fiveRows,
                  count: game.world.bonusService.bonuses[BonusType.fiveRows]!);
            },
            BonusType.batterySaver.name:
                (BuildContext context, WhaleyGame game) {
              return BonusOverlay(
                  bonusType: BonusType.batterySaver,
                  count:
                      game.world.bonusService.bonuses[BonusType.batterySaver]!);
            },
            BonusType.highspeed.name: (BuildContext context, WhaleyGame game) {
              return BonusOverlay(
                  bonusType: BonusType.highspeed,
                  count: game.world.bonusService.bonuses[BonusType.highspeed]!);
            },
            achievementDialogKey: (BuildContext context, WhaleyGame game) {
              return AchievementOverlay(
                  game: game, achievementType: game.world.achievementType!);
            },
          },
        ),
      ),
    );
  }
}
