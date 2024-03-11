import 'package:endless_runner/flame_game/you_win_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:nes_ui/nes_ui.dart';

import '../../constants.dart';
import '../../gen/assets.gen.dart';
import '../../player_progress/level_progress.dart';
import '../../style/gaps.dart';
import '../../style/palette.dart';

/// This dialog is shown when a level is completed.
///
/// It shows what score the level was completed with and if there are more
/// levels it lets the user go to the next level, or otherwise back to the level
/// selection screen.
class LevelWinDialog extends StatelessWidget {
  const LevelWinDialog({
    super.key,
    required this.levelProgress,
  });

  final LevelProgress levelProgress;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            NesContainer(
              padding:
                  const EdgeInsets.only(top: 32, bottom: 80, left: 8, right: 8),
              width: 240,
              backgroundColor: Palette.darkBlue,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildButtons(context),
                  Gaps.verticalM,
                  Text(
                    'SCORE: ${levelProgress.score}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Palette.white,
                        ),
                  ),
                  Gaps.verticalM,
                  Text(
                    'LEVEL: ${levelProgress.levelNumber}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Palette.white,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  Gaps.verticalXL,
                  _buildStars(levelProgress.stars),
                ],
              ),
            ),
            const YouWinBanner(isParentPortrait: true),
          ],
        ),
      ),
    );
  }

  Widget _buildStars(int stars) {
    return SizedBox(
      width: 120,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(
          3,
          (index) {
            return Expanded(
              flex: index == 1 ? 4 : 3,
              child: index < stars
                  ? Assets.images.starGold.image(
                      semanticLabel: 'Star',
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.none)
                  : ExcludeSemantics(
                      child: Assets.images.starBlue.image(
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.none),
                    ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Semantics(
          button: true,
          label: 'Replay level',
          child: NesButton(
            type: NesButtonType.normal,
            onPressed: () {
              HapticFeedback.lightImpact();
              GoRouter.of(context)
                  .go('/play/session/${levelProgress.levelNumber}');
            },
            child: NesIcon(iconData: NesIcons.redo),
          ),
        ),
        if (levelProgress.levelNumber < Constants.lastLevelNumber) ...[
          const SizedBox(width: 8),
          Semantics(
            button: true,
            label: 'Next level',
            child: NesButton(
              type: NesButtonType.normal,
              onPressed: () {
                HapticFeedback.lightImpact();
                context.go('/play/session/${levelProgress.levelNumber + 1}');
              },
              child: NesIcon(iconData: NesIcons.rightArrowIndicator),
            ),
          ),
        ],
      ],
    );
  }
}
