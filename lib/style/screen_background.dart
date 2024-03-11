import 'package:endless_runner/style/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../gen/assets.gen.dart';
import '../settings/settings.dart';

class ScreenBackground extends StatelessWidget {
  final Widget child;

  const ScreenBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();

    return ValueListenableBuilder<bool>(
      valueListenable: settings.increasedContrast,
      builder: (_, bool increasedContrast, __) {
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: increasedContrast ? Colors.black : Colors.transparent,
                image: DecorationImage(
                  image: Assets.images.bgClean.provider(),
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.none,
                  opacity: increasedContrast ? 0.5 : 1,
                ),
              ),
              child: child,
            ),
            Align(
              alignment: Alignment.topRight,
              child: MergeSemantics(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Semantics(
                    liveRegion: true,
                    button: true,
                    label: increasedContrast
                        ? 'Default contrast'
                        : 'Increased contrast',
                    child: IconButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        settings.toggleIncreasedContrast();
                      },
                      icon: Icon(
                        increasedContrast
                            ? Icons.dark_mode
                            : Icons.dark_mode_outlined,
                        color: Palette.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
