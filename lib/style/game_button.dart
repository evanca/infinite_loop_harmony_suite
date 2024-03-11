import 'package:endless_runner/style/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GameButton extends StatelessWidget {
  const GameButton({super.key, required this.child, required this.onPressed});

  final Widget child;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onPressed();
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Palette.bannerBackground,
          border: Border(
            top: BorderSide(color: Palette.logoPink, width: 4),
            left: BorderSide(color: Palette.logoPink, width: 4),
            bottom: BorderSide(color: Colors.black, width: 4),
            right: BorderSide(color: Colors.black, width: 4),
          ),
        ),
        child: DefaultTextStyle(
          style: Theme.of(context).textTheme.bodyMedium ?? const TextStyle(),
          child: child,
        ),
      ),
    );
  }
}
