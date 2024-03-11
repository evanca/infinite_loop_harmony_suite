import 'package:endless_runner/flame_game/whaley_game.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nes_ui/nes_ui.dart';

import '../constants.dart';

class LevelHeaderOverlay extends StatelessWidget {
  final WhaleyGame game;

  const LevelHeaderOverlay({
    required this.game,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      label: 'Game field header',
      child: SafeArea(
        minimum: EdgeInsets.only(top: 10, left: game.isPortrait ? 10 : 0),
        child: Align(
          alignment: Alignment.topCenter,
          child: AspectRatio(
            aspectRatio: Constants.desktopMainAreaSize.x /
                Constants.desktopMainAreaSize.y,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      _buildBackButton(context),
                      const Spacer(),
                      _buildHighspeedCountdown(game),
                      const Spacer(),
                    ],
                  ),
                ),
                _buildScore(game),
                const Spacer()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Back',
      child: NesButton(
        type: NesButtonType.normal,
        onPressed: GoRouter.of(context).pop,
        child: NesIcon(iconData: NesIcons.leftArrowIndicator),
      ),
    );
  }

  Widget _buildScore(WhaleyGame game) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ValueListenableBuilder(
          valueListenable: game.world.scoreNotifier,
          builder: (context, score, _) {
            return Text(
              'LEVEL: ${game.world.level.number} '
              '${game.isPortrait ? "\n" : "   "}'
              'SCORE: ${score.toString()}',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(height: 1.5),
            );
          }),
    );
  }

  Widget _buildHighspeedCountdown(WhaleyGame game) {
    return ValueListenableBuilder(
        valueListenable: game.world.countdownNotifier,
        builder: (context, countdown, _) {
          if (countdown == 0) {
            return const ExcludeSemantics(child: SizedBox.shrink());
          }
          return Semantics(
            label: 'Highspeed countdown',
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  countdown.toString(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(height: 1.5),
                ),
                ExcludeSemantics(child: NesIcon(iconData: iconData(countdown))),
              ],
            ),
          );
        });
  }

  NesIconData iconData(int seconds) {
    return switch (seconds) {
      3 => NesIcons.hourglassTopFull,
      2 => NesIcons.hourglassMiddle,
      _ => NesIcons.hourglassBottomFull,
    };
  }
}
