import 'package:endless_runner/audio/audio_controller.dart';
import 'package:endless_runner/audio/sounds.dart';
import 'package:endless_runner/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../player_progress/level_progress.dart';

/// A widget displaying a level badge, including the level number and stars
/// earned. If the level is locked, a lock icon is displayed instead.
class LevelBadge extends StatelessWidget {
  final LevelProgress levelProgress;
  final bool locked;

  const LevelBadge({
    super.key,
    required this.levelProgress,
    this.locked = false,
  });

  @override
  Widget build(BuildContext context) {
    final levelTextStyle =
        Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white);

    return Semantics(
      label: 'Level ${levelProgress.levelNumber} ${locked ? "locked" : ""}',
      button: true,
      child: GestureDetector(
        onTap: () {
          if (locked) return;

          final audioController = context.read<AudioController>();
          audioController.playSfx(SfxType.buttonTap);

          GoRouter.of(context).go('/play/session/${levelProgress.levelNumber}');
        },
        child: DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: Assets.images.level.provider(),
                fit: BoxFit.fill,
                filterQuality: FilterQuality.none,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                locked
                    ? const Spacer(flex: 3)
                    : _buildStars(levelProgress.stars),
                const Spacer(flex: 2),
                locked
                    ? FractionallySizedBox(
                        widthFactor: 0.25, child: Assets.images.lock.image())
                    : Text('${levelProgress.levelNumber}',
                        style: levelTextStyle),
                const Spacer(flex: 3),
              ],
            )),
      ),
    );
  }

  Widget _buildStars(int stars) {
    return Semantics(
      label: '${stars == 0 ? "No" : stars} stars',
      child: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: FractionallySizedBox(
          widthFactor: 0.68,
          child: ExcludeSemantics(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(
                3,
                (index) {
                  return Expanded(
                      flex: index == 1 ? 4 : 3,
                      child: index < stars
                          ? Assets.images.starGold.image()
                          : Assets.images.starBlue.image());
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
