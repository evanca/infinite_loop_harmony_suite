import 'package:endless_runner/style/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nes_ui/nes_ui.dart';

import '../style/gaps.dart';

/// Displays a text field with a masked answer as the label, allowing users
/// to input their answer.
class AnswerInputForm extends StatefulWidget {
  const AnswerInputForm({
    super.key,
    required this.maskedAnswer,
    required this.answer,
    required this.onAnswerCorrect,
    required this.onClose,
    required this.focusNode,
  });

  final String maskedAnswer;
  final String answer;
  final VoidCallback onAnswerCorrect;
  final VoidCallback onClose;
  final FocusNode focusNode;

  @override
  State<AnswerInputForm> createState() => _AnswerInputFormState();
}

class _AnswerInputFormState extends State<AnswerInputForm> {
  static const String _defaultErrorText = 'Try again';
  final TextEditingController controller = TextEditingController();

  String? errorText;

  @override
  void initState() {
    controller.addListener(() {
      setState(() {
        errorText = _validate(controller.text, widget.answer);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Semantics(
          textField: true,
          label: 'Answer',
          hint: errorText ?? 'Enter your answer',
          value: controller.text,
          child: TextField(
            focusNode: widget.focusNode,
            controller: controller,
            maxLength: widget.answer.length,
            decoration: InputDecoration(
              fillColor: Palette.white,
              filled: true,
              labelText: widget.maskedAnswer,
              labelStyle: const TextStyle(
                color: Palette.darkBlue,
              ),
              helperMaxLines: 2,
              errorText: errorText,
              errorStyle: const TextStyle(
                color: Palette.errorRed,
              ),
            ),
          ),
        ),
        Gaps.verticalXL,
        _buildButtons(context, controller),
      ],
    );
  }

  String? _validate(String? value, String answer) {
    if (value == null || value.isEmpty || value.length != answer.length) {
      return null;
    }
    return _canSubmit(value, answer) ? null : _defaultErrorText;
  }

  bool _canSubmit(String value, String answer) {
    return value.toLowerCase() == answer.toLowerCase();
  }

  Widget _buildButtons(BuildContext context, TextEditingController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Semantics(
          button: true,
          label: 'Submit answer',
          child: NesButton(
            type: NesButtonType.normal,
            onPressed: () {
              HapticFeedback.lightImpact();
              if (!_canSubmit(controller.text, widget.answer)) {
                setState(() {
                  errorText = _defaultErrorText;
                });
                return;
              } else {
                widget.onAnswerCorrect();
              }
            },
            child: NesIcon(iconData: NesIcons.check),
          ),
        ),
        const SizedBox(width: 8),
        Semantics(
          button: true,
          label: 'Close form dialog',
          child: NesButton(
            type: NesButtonType.normal,
            onPressed: () {
              HapticFeedback.lightImpact();
              widget.onClose();
            },
            child: NesIcon(iconData: NesIcons.close),
          ),
        ),
      ],
    );
  }
}
