import 'package:endless_runner/questions/question_dialog.dart';
import 'package:endless_runner/questions/question_repository.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants.dart';
import '../../gen/assets.gen.dart';
import '../../player_progress/level_progress.dart';
import '../../player_progress/player_progress.dart';
import '../../questions/question.dart';
import '../../style/gaps.dart';
import '../../style/palette.dart';

/// This dialog is shown when a level is completed.
///
/// It shows what score the level was completed with and if there are more
/// levels it lets the user go to the next level, or otherwise back to the level
/// selection screen.
class LevelLoseDialog extends StatefulWidget {
  const LevelLoseDialog({
    super.key,
    required this.levelProgress,
  });

  final LevelProgress levelProgress;

  @override
  State<LevelLoseDialog> createState() => _LevelLoseDialogState();
}

class _LevelLoseDialogState extends State<LevelLoseDialog> {
  Widget? container;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
          future: QuestionRepository().fetchRandomQuestion(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }

            final Question question = snapshot.data!;
            container ??= _buildLoseContainer(context, question);

            return container!;
          }),
    );
  }

  Semantics _buildLoseContainer(BuildContext context, Question question) {
    return Semantics(
      container: true,
      child: NesContainer(
        padding:
            const EdgeInsets.only(top: 32, bottom: 16, left: 24, right: 24),
        width: 340,
        backgroundColor: Palette.bannerBackground.withOpacity(.75),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _buildButtons(context, question),
            Gaps.verticalM,
            Text('SCORE: ${widget.levelProgress.score}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 50),
            Text('DID YOU KNOW?',
                style: Theme.of(context).textTheme.bodyMedium),
            Gaps.verticalM,
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(height: 1.5),
                children: [
                  TextSpan(text: question.fact),
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launchUrl(Uri.parse(question.sourceUrl));
                      },
                    text: '[SOURCE]',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Palette.darkBlue, height: 1.8),
                  ),
                ],
              ),
            ),
            Gaps.verticalM,
            Semantics(
              image: true,
              child: Assets.images.whaleySpeaking.image(
                  semanticLabel: 'Whaley speaking',
                  width: 240,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.none),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context, Question question) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Semantics(
          button: true,
          label: 'Retry level',
          child: NesButton(
            type: NesButtonType.normal,
            onPressed: () {
              HapticFeedback.lightImpact();
              GoRouter.of(context)
                  .go('/play/session/${widget.levelProgress.levelNumber}');
            },
            child: NesIcon(iconData: NesIcons.redo),
          ),
        ),
        if (widget.levelProgress.levelNumber < Constants.lastLevelNumber) ...[
          const SizedBox(width: 8),
          Consumer<PlayerProgress>(builder: (_, playerProgress, __) {
            return Semantics(
              button: true,
              label: 'Next level',
              child: NesButton(
                type: NesButtonType.normal,
                onPressed: () async {
                  HapticFeedback.lightImpact();
                  final int nextLevel = widget.levelProgress.levelNumber + 1;
                  final bool nextAlreadyUnlocked =
                      playerProgress.levels.containsKey(nextLevel);

                  if (nextAlreadyUnlocked) {
                    GoRouter.of(context).go('/play/session/$nextLevel');
                  } else {
                    // Show question dialog
                    setState(() {
                      container = QuestionDialog(
                          question: question,
                          levelProgress: widget.levelProgress,
                          onAnswerCorrect: () {
                            playerProgress.maybeUnlockLevel(nextLevel);
                          },
                          onClose: () {
                            setState(() {
                              container =
                                  _buildLoseContainer(context, question);
                            });
                          });
                    });
                  }
                },
                child: NesIcon(iconData: NesIcons.rightArrowIndicator),
              ),
            );
          }),
        ],
      ],
    );
  }
}
