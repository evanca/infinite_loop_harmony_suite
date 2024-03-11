import 'package:endless_runner/constants.dart';
import 'package:endless_runner/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../settings/custom_name_dialog.dart';
import '../settings/settings.dart';
import '../style/responsive_screen.dart';
import '../style/wobbly_button.dart';
import 'intro_dialog.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsController = context.watch<SettingsController>();
    final audioController = context.watch<AudioController>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Assets.images.bgSplash.provider(),
            fit: BoxFit.cover,
            filterQuality: FilterQuality.none,
          ),
        ),
        child: ResponsiveScreen(
          squarishMainAreaBuilder: (context, _) => Center(
            child: Semantics(
              label: 'Whaley\'s Bins logo',
              child: FractionallySizedBox(
                  heightFactor: 0.3, child: Assets.images.logo.image()),
            ),
          ),
          rectangularMenuArea: ValueListenableBuilder<bool?>(
              valueListenable: settingsController.introSeen,
              builder: (context, introSeen, _) {
                if (introSeen == null) {
                  return Semantics(
                      label: 'Loading indicator',
                      child: const CircularProgressIndicator());
                }

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!introSeen) {
                    showDialog(
                      context: context,
                      builder: (context) => IntroDialog(
                        onDismiss: () {
                          settingsController.setIntroSeen();
                          Navigator.of(context).pop();
                        },
                      ),
                    ).whenComplete(() => showCustomNameDialog(context));
                  }
                });

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    WobblyButton(
                      onPressed: () {
                        audioController.playSfx(SfxType.buttonTap);
                        GoRouter.of(context).go('/play');
                      },
                      child: const Text('Play'),
                    ),
                    Constants.gap,
                    WobblyButton(
                      onPressed: () => GoRouter.of(context).push('/settings'),
                      child: const Text('Settings'),
                    ),
                    Constants.gap,
                    MergeSemantics(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 32),
                        child: ValueListenableBuilder<bool>(
                          valueListenable: settingsController.audioOn,
                          builder: (context, audioOn, child) {
                            return Semantics(
                              label:
                                  'Toggle audio: is ${audioOn ? 'on' : 'off'}',
                              button: true,
                              child: IconButton(
                                onPressed: () {
                                  HapticFeedback.lightImpact();
                                  settingsController.toggleAudioOn();
                                },
                                icon: Icon(
                                    audioOn
                                        ? Icons.volume_up
                                        : Icons.volume_off,
                                    color: Colors.white),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Constants.gap,
                  ],
                );
              }),
        ),
      ),
    );
  }
}
