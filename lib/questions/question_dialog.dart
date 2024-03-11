import 'package:endless_runner/player_progress/player_progress.dart';
import 'package:endless_runner/questions/answer_input_form.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:provider/provider.dart';

import '../../questions/question.dart';
import '../../style/palette.dart';
import '../player_progress/level_progress.dart';
import '../style/gaps.dart';

/// Displays a question and an input form for the user to submit their answer,
/// aiming to unlock the next level by correctly answering.
class QuestionDialog extends StatefulWidget {
  const QuestionDialog({
    super.key,
    required this.question,
    required this.levelProgress,
    required this.onAnswerCorrect,
    required this.onClose,
  });

  final Question question;
  final LevelProgress levelProgress;
  final VoidCallback onAnswerCorrect;
  final VoidCallback onClose;

  @override
  State<QuestionDialog> createState() => _QuestionDialogState();
}

class _QuestionDialogState extends State<QuestionDialog> {
  final _focusNode = FocusNode();
  bool _hideText = false;

  @override
  void initState() {
    // Listen to keyboard visibility to hide the text when the keyboard is shown
    _focusNode.addListener(() {
      setState(() {
        _hideText = _focusNode.hasFocus;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NesContainer(
      padding: const EdgeInsets.only(top: 32, bottom: 16, left: 24, right: 24),
      width: 340,
      backgroundColor: Palette.bannerBackground.withOpacity(.75),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (!_hideText) ...[
            Text('NOT ENOUGH POINTS',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Palette.errorRed),
                textAlign: TextAlign.center),
            Gaps.verticalM,
            Text('CAN YOU ANSWER THIS TO UNLOCK NEXT LEVEL?',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center),
            Gaps.verticalXL,
            Text(
              widget.question.question,
              style:
                  Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
              textAlign: TextAlign.center,
            ),
            Gaps.verticalXL,
          ],
          AnswerInputForm(
            focusNode: _focusNode,
            maskedAnswer: widget.question.maskedAnswer,
            answer: widget.question.answer,
            onAnswerCorrect: () {
              context
                  .read<PlayerProgress>()
                  .maybeUnlockLevel(widget.levelProgress.levelNumber + 1);
              GoRouter.of(context)
                  .go('/play/session/${widget.levelProgress.levelNumber + 1}');
            },
            onClose: widget.onClose,
          ),
        ],
      ),
    );
  }
}
