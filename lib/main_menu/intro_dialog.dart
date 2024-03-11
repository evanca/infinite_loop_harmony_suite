import 'package:endless_runner/style/game_button.dart';
import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';

import '../../gen/assets.gen.dart';
import '../../style/palette.dart';
import '../style/gaps.dart';

/// Displays an introductory dialog in a game, guiding the player on how to sort waste
/// and highlighting the importance of recycling for marine conservation.
///
/// This dialog walks the player through two main messages in a paginated format. The first page
/// introduces the game's core mechanics—sorting waste into the correct bins. The second page
/// emphasizes the environmental impact of recycling and proper waste sorting, particularly on
/// marine life like whales. It includes a dismissable action that triggers the provided
/// `onDismiss` callback, moving the player forward in the game experience.
class IntroDialog extends StatefulWidget {
  const IntroDialog({super.key, required this.onDismiss});

  /// A callback function that is called when the dialog is dismissed, allowing
  /// for further game progression.
  final VoidCallback onDismiss;

  static const _pageOneIntroMessage = 'Help me sort the waste into '
      'the appropriate bins. Swap an item with another to change its position '
      'above the bin.';

  static const _pageTwoIntroMessage =
      'By recycling plastics and properly sorting waste, we can '
      'ensure less rubbish ends up in the ocean, reducing the risk to whales '
      'and other marine species.\n\nGood luck.';

  @override
  State<IntroDialog> createState() => _IntroDialogState();
}

class _IntroDialogState extends State<IntroDialog> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: NesContainer(
        padding:
            const EdgeInsets.only(top: 32, bottom: 16, left: 24, right: 24),
        width: 340,
        backgroundColor: Palette.bannerBackground.withOpacity(.95),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (_currentPage == 0)
              ..._buildPageOne(context)
            else
              ..._buildPageTwo(context),
            Gaps.verticalM,
            Semantics(
              image: true,
              child: Assets.images.whaleySpeaking.image(
                  semanticLabel: 'Whaley speaking',
                  width: 240,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.none),
            ),
            Gaps.verticalM,
            _buildNextButton(context),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPageOne(BuildContext context) {
    return [
      Text('Hi! I\'m Whaley!', style: Theme.of(context).textTheme.bodyMedium),
      Gaps.verticalM,
      Text(
        IntroDialog._pageOneIntroMessage,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
        textAlign: TextAlign.center,
      ),
    ];
  }

  List<Widget> _buildPageTwo(BuildContext context) {
    return [
      Text(
        IntroDialog._pageTwoIntroMessage,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
        textAlign: TextAlign.center,
      ),
    ];
  }

  Widget _buildNextButton(BuildContext context) {
    final String label = _currentPage == 0 ? 'Next' : 'Start';
    return GameButton(
        child: Text(label),
        onPressed: () {
          if (_currentPage == 0) {
            setState(() {
              _currentPage++;
            });
          } else {
            widget.onDismiss();
          }
        });
  }
}
