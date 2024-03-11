import 'package:endless_runner/settings/settings.dart';
import 'package:endless_runner/style/palette.dart';
import 'package:endless_runner/style/responsive_screen.dart';
import 'package:endless_runner/style/screen_background.dart';
import 'package:endless_runner/style/text_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../player_progress/player_progress.dart';
import '../style/wobbly_button.dart';
import 'custom_name_dialog.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const _gap = SizedBox(height: 60);

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();

    return Material(
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Colors.white,
            ),
        child: ScreenBackground(
          child: ResponsiveScreen(
            topMessageAreaBuilder: (context, isPortrait) => TextBanner(
              title: 'Settings',
              isParentPortrait: isPortrait,
            ),
            squarishMainAreaBuilder: (context, isPortrait) => Center(
              child: Column(
                children: [
                  Expanded(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 300,
                      ),
                      child: ListView(
                        children: [
                          _gap,
                          const _NameChangeLine(
                            'Name',
                          ),
                          ValueListenableBuilder<bool>(
                            valueListenable: settings.soundsOn,
                            builder: (context, soundsOn, child) =>
                                _SettingsLine(
                              'Sound FX',
                              Semantics(
                                label: soundsOn ? 'is on' : 'is off',
                                liveRegion: true,
                                child: Icon(
                                  soundsOn ? Icons.volume_up : Icons.volume_off,
                                  color: Palette.white,
                                ),
                              ),
                              onSelected: () => settings.toggleSoundsOn(),
                            ),
                          ),
                          ValueListenableBuilder<bool>(
                            valueListenable: settings.musicOn,
                            builder: (context, musicOn, child) => _SettingsLine(
                              'Music',
                              Semantics(
                                label: musicOn ? 'is on' : 'is off',
                                liveRegion: true,
                                child: Icon(
                                    musicOn
                                        ? Icons.music_note
                                        : Icons.music_off,
                                    color: Palette.white),
                              ),
                              onSelected: () => settings.toggleMusicOn(),
                            ),
                          ),
                          _SettingsLine(
                            'How to play',
                            const Icon(Icons.gamepad_outlined,
                                color: Palette.white),
                            onSelected: () {
                              GoRouter.of(context).go('/info');
                            },
                          ),
                          _SettingsLine(
                            'Leaderboard',
                            const Icon(Icons.emoji_events_outlined,
                                color: Palette.white),
                            onSelected: () {
                              GoRouter.of(context).go('/leaderboard');
                            },
                          ),
                          _SettingsLine(
                            'Reset progress',
                            const Icon(Icons.delete, color: Palette.white),
                            onSelected: () {
                              context.read<PlayerProgress>().reset();

                              final messenger = ScaffoldMessenger.of(context);
                              messenger.showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Player progress has been reset.')),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  _gap,
                ],
              ),
            ),
            rectangularMenuArea: WobblyButton(
              onPressed: () {
                GoRouter.of(context).go('/');
              },
              child: const Text('Back'),
            ),
          ),
        ),
      ),
    );
  }
}

class _NameChangeLine extends StatelessWidget {
  final String title;

  const _NameChangeLine(this.title);

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();

    return Semantics(
      button: true,
      child: InkResponse(
        highlightShape: BoxShape.rectangle,
        onTap: () {
          HapticFeedback.lightImpact();
          showCustomNameDialog(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title),
              const Spacer(),
              ValueListenableBuilder(
                valueListenable: settings.playerName,
                builder: (context, name, child) => Text(
                  '"$name"',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsLine extends StatelessWidget {
  final String title;

  final Widget icon;

  final VoidCallback? onSelected;

  const _SettingsLine(this.title, this.icon, {this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: InkResponse(
        highlightShape: BoxShape.rectangle,
        onTap: () {
          HapticFeedback.lightImpact();
          onSelected?.call();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              icon,
            ],
          ),
        ),
      ),
    );
  }
}
