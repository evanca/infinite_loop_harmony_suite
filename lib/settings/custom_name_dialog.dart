import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:provider/provider.dart';

import '../style/gaps.dart';
import '../style/palette.dart';
import 'settings.dart';

void showCustomNameDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return const CustomNameDialog();
      });
}

class CustomNameDialog extends StatefulWidget {
  const CustomNameDialog({super.key});

  @override
  State<CustomNameDialog> createState() => _CustomNameDialogState();
}

class _CustomNameDialogState extends State<CustomNameDialog> {
  final TextEditingController _controller = TextEditingController();
  String? errorText;

  @override
  initState() {
    _controller.text = context.read<SettingsController>().playerName.value;
    _controller.addListener(() {
      setState(() {
        errorText = _validate(_controller.text);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Semantics(
          container: true,
          label: 'Custom name dialog',
          child: NesContainer(
            padding:
                const EdgeInsets.only(top: 32, bottom: 16, left: 24, right: 24),
            width: 340,
            height: 240,
            backgroundColor: Palette.bannerBackground,
            child: Column(
              children: [
                Semantics(
                  textField: true,
                  label: 'Public player name',
                  hint: errorText ?? 'Enter your name',
                  maxValueLength: 20,
                  currentValueLength: _controller.text.length,
                  value: _controller.text,
                  child: TextField(
                    controller: _controller,
                    maxLength: 20,
                    decoration: InputDecoration(
                      fillColor: Palette.white,
                      filled: true,
                      labelText: 'Public player name',
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
                _buildButtons(context, _controller),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Can\'t be empty';
    }
    return null;
  }

  Widget _buildButtons(BuildContext context, TextEditingController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Semantics(
          button: true,
          label: 'Save player name',
          child: NesButton(
            type: NesButtonType.normal,
            onPressed: () {
              HapticFeedback.lightImpact();
              if (controller.text.isEmpty) {
                return;
              }
              context.read<SettingsController>().setPlayerName(controller.text);
              Navigator.pop(context);
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
              Navigator.pop(context);
            },
            child: NesIcon(iconData: NesIcons.close),
          ),
        ),
      ],
    );
  }
}
