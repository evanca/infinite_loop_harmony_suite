import 'dart:io';
import 'dart:ui';

import 'package:endless_runner/flame_game/components/bin.dart';
import 'package:endless_runner/flame_game/constants/trash_items.dart';
import 'package:endless_runner/gen/assets.gen.dart';
import 'package:endless_runner/settings/settings.dart';
import 'package:endless_runner/style/responsive_screen.dart';
import 'package:endless_runner/style/screen_background.dart';
import 'package:endless_runner/style/text_banner.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../style/gaps.dart';
import '../style/palette.dart';
import '../style/wobbly_button.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Colors.white,
              height: 1.8,
            ),
        child: ScreenBackground(
          child: ResponsiveScreen(
            topMessageAreaBuilder: (context, isPortrait) => TextBanner(
              title: 'How to play',
              isParentPortrait: isPortrait,
            ),
            squarishMainAreaBuilder: (context, isPortrait) =>
                ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                },
              ),
              child: ListView(
                children: [
                  Gaps.verticalM,
                  const Text(
                    'Swap items in each "row" by dragging one item onto another. The goal is to place each item into the correct waste bin. Earn bonuses for completing rows entirely correctly.',
                  ),
                  Gaps.verticalL,
                  if (!kIsWeb && Platform.isIOS) ...[
                    const Text(
                      'Earn a special bonus by activating "battery saver mode" on iOS, contributing to a greener planet',
                    ),
                    Gaps.verticalL,
                  ],
                  const Text(
                      'Sometimes, a "highspeed lane" will activate, and items'
                      ' above one bin will move at a different speed until the end of the level!'),
                  Gaps.verticalXXL,
                  _buildBinSection(
                    context,
                    color: BinColor.red.colorValue,
                    title: 'RED BIN: Hazardous waste',
                    images: TrashItems.byBinColor[BinColor.red]!,
                  ),
                  Gaps.verticalXXL,
                  _buildBinSection(
                    context,
                    color: BinColor.yellow.colorValue,
                    title: 'YELLOW BIN: Recyclable packaging',
                    images: TrashItems.byBinColor[BinColor.yellow]!,
                  ),
                  Gaps.verticalXXL,
                  _buildBinSection(
                    context,
                    color: BinColor.green.colorValue,
                    title: 'GREEN BIN: Biodegradable waste',
                    images: TrashItems.byBinColor[BinColor.green]!,
                  ),
                  Gaps.verticalXXL,
                  _buildBinSection(
                    context,
                    color: BinColor.blue.colorValue,
                    title: 'BLUE BIN: Paper and cardboard',
                    images: TrashItems.byBinColor[BinColor.blue]!,
                  ),
                  Gaps.verticalXXL,
                  _buildBinSection(
                    context,
                    color: BinColor.black.colorValue,
                    title: 'BLACK BIN: General waste',
                    images: TrashItems.byBinColor[BinColor.black]!,
                  ),
                  Gaps.verticalXL,
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

  Widget _buildBinSection(BuildContext context,
      {required Color color,
      required String title,
      required List<AssetGenImage> images}) {
    return ValueListenableBuilder<bool>(
        valueListenable: context.read<SettingsController>().increasedContrast,
        builder: (_, bool increasedContrast, __) {
          // Use more contrast for a special case of yellow background
          // Based on color.computeLuminance() > 0.5 result
          final Color labelColor = increasedContrast
              ? Palette.white
              : color == BinColor.yellow.colorValue
                  ? Colors.black
                  : Palette.white;

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: increasedContrast
                      ? HSLColor.fromColor(color).withLightness(0.15).toColor()
                      : color,
                  border: Border.all(color: labelColor),
                ),
                child: Text(title, style: TextStyle(color: labelColor)),
              ),
              Gaps.verticalM,
              Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 32,
                  runSpacing: 16,
                  children: List.generate(5, (index) {
                    final AssetGenImage image = images[index];
                    final String label = TrashItems.labels[image]!;
                    return _buildImageWithLabel(image, label);
                  })),
            ],
          );
        });
  }

  Widget _buildImageWithLabel(AssetGenImage image, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
            width: 50,
            child: ExcludeSemantics(
                child: AspectRatio(aspectRatio: 1, child: image.image()))),
        Gaps.verticalS,
        Text(label, textAlign: TextAlign.center),
      ],
    );
  }
}
