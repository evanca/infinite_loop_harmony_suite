import 'package:endless_runner/achievements/google_wallet_service.dart';
import 'package:endless_runner/flame_game/whaley_game.dart';
import 'package:flutter/material.dart';
import 'package:google_wallet/google_wallet.dart';
import 'package:share_plus/share_plus.dart';

import '../flame_game/game_screen.dart';
import '../style/game_button.dart';
import '../style/gaps.dart';
import '../style/palette.dart';
import 'achievement.dart';

/// Displays an overlay to celebrate the unlocking of an achievement.
///
/// This widget is centered on the screen and showcases details of the achieved milestone,
/// including its title, description, and associated image. Depending on the availability
/// of Google Wallet on the device, it optionally presents a button for saving the achievement
/// to Google Wallet. Additionally, it offers a 'Share' button, allowing users to share their
/// achievement, and a 'Close' button to dismiss the overlay.
class AchievementOverlay extends StatelessWidget {
  final WhaleyGame game;
  final Achievement achievement;
  final GoogleWalletService _googleWalletService;

  AchievementOverlay({
    super.key,
    required this.game,
    required AchievementType achievementType,
    GoogleWalletService? googleWalletService,
  })  : achievement = Achievement.byType(achievementType),
        _googleWalletService = googleWalletService ?? GoogleWalletService();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: Center(
        child: Container(
          padding: const EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
            border: Border.all(
              color: Palette.white,
              width: 3,
            ),
            color: Palette.darkBlue,
          ),
          width: 340,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('Achievement unlocked:',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Palette.white,
                      )),
              Gaps.verticalM,
              Text('"${achievement.title.toUpperCase()}"',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Palette.white,
                      )),
              Gaps.verticalM,
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Semantics(
                    image: true,
                    child: achievement.image.image(
                      semanticLabel: achievement.title,
                      width: double.infinity,
                      filterQuality: FilterQuality.none,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Column(
                      children: [
                        FutureBuilder(
                            future: _googleWalletService.isAvailable(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData && snapshot.data == true) {
                                return Semantics(
                                    button: true,
                                    label: 'Save to Google Wallet',
                                    child: GoogleWalletButton(
                                        style:
                                            GoogleWalletButtonStyle.condensed,
                                        onPressed: () => GoogleWalletService()
                                            .savePass(achievement)));
                              }
                              return const ExcludeSemantics(
                                  child: SizedBox.shrink());
                            }),
                        Gaps.verticalM,
                        Row(
                          children: [
                            GameButton(
                              child: const Text('Share'),
                              onPressed: () {
                                Share.share(
                                    'I just unlocked the "${achievement.title}"'
                                    ' achievement in Whaley\'s Bins! Can you beat my score?');
                              },
                            ),
                            const SizedBox(width: 8),
                            GameButton(
                              child: const Text('Close'),
                              onPressed: () {
                                game.overlays
                                    .remove(GameScreen.achievementDialogKey);
                              },
                            ),
                          ],
                        ),
                        Gaps.verticalS,
                      ],
                    ),
                  ),
                ],
              ), // Hero image
            ],
          ),
        ),
      ),
    );
  }
}
