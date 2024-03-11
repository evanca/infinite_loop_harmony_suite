import 'package:endless_runner/settings/info_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import 'flame_game/game_screen.dart';
import 'leaderboard/leaderboard_screen.dart';
import 'level_selection/level_manager.dart';
import 'level_selection/level_selection_screen.dart';
import 'main_menu/main_menu_screen.dart';
import 'settings/settings_screen.dart';
import 'style/page_transition.dart';
import 'style/palette.dart';

/// The router describes the game's navigational hierarchy, from the main
/// screen through settings screens all the way to each individual level.
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainMenuScreen(key: Key('main menu')),
      routes: [
        GoRoute(
          path: 'play',
          pageBuilder: (context, state) => buildPageTransition<void>(
            key: const ValueKey('play'),
            color: Palette.backgroundLevelSelection,
            child: const LevelSelectionScreen(
              key: Key('level selection'),
            ),
          ),
          routes: [
            GoRoute(
              path: 'session/:level',
              pageBuilder: (context, state) {
                final levelNumber = int.parse(state.pathParameters['level']!);
                final level = LevelManager().generateLevel(levelNumber);
                return buildPageTransition<void>(
                  key: const ValueKey('level'),
                  color: Palette.backgroundPlaySession,
                  child: GameScreen(level: level),
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: 'settings',
          builder: (context, state) => const SettingsScreen(
            key: Key('settings'),
          ),
        ),
        GoRoute(
          path: 'leaderboard',
          builder: (context, state) => LeaderboardScreen(
            key: const Key('leaderboard'),
          ),
        ),
        GoRoute(
          path: 'info',
          builder: (context, state) => const InfoScreen(
            key: Key('info'),
          ),
        ),
      ],
    ),
  ],
);
