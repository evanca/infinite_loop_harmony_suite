import 'dart:ui';

import 'package:endless_runner/level_selection/level_badge.dart';
import 'package:endless_runner/style/responsive_screen.dart';
import 'package:endless_runner/style/screen_background.dart';
import 'package:endless_runner/style/text_banner.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../player_progress/level_progress.dart';
import '../player_progress/player_progress.dart';
import '../style/wobbly_button.dart';

class LevelSelectionScreen extends StatelessWidget {
  const LevelSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: ResponsiveScreen(
        topMessageAreaBuilder: (context, isPortrait) => TextBanner(
          title: 'Select level',
          isParentPortrait: isPortrait,
        ),
        squarishMainAreaBuilder: (context, isPortrait) => ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
            },
          ),
          child:
              Consumer<PlayerProgress>(builder: (context, playerProgress, _) {
                return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 138 / 130,
                mainAxisSpacing: isPortrait ? 16 : 24,
                crossAxisSpacing: isPortrait ? 20 : 24,
                crossAxisCount: isPortrait && !kIsWeb ? 3 : 4,
              ),
              padding: EdgeInsets.symmetric(horizontal: isPortrait ? 16 : 32)
                  .copyWith(top: isPortrait ? 16 : 0),
              itemCount: Constants.lastLevelNumber,
              itemBuilder: (context, index) {
                final levelNumber = index + 1;
                final bool unlocked =
                    playerProgress.levels.containsKey(levelNumber);
                return unlocked
                    ? LevelBadge(
                        levelProgress: playerProgress.levels[levelNumber]!)
                    : LevelBadge(
                        levelProgress: LevelProgress.initial(levelNumber),
                        locked: true);
              },
            );
          }),
        ),
        rectangularMenuArea: Wrap(
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            WobblyButton(
              onPressed: () {
                GoRouter.of(context).go('/');
              },
              child: const Text('Back'),
            ),
            WobblyButton(
              onPressed: () {
                GoRouter.of(context).go('/info');
              },
              child: const Text('Info'),
            ),
            WobblyButton(
              onPressed: () {
                GoRouter.of(context).go('/leaderboard');
              },
              child: const Text('Leaderboard'),
            ),
          ],
        ),
      ),
    );
  }
}
