import 'dart:math';

import 'package:endless_runner/style/game_button.dart';
import 'package:flutter/material.dart';

class WobblyButton extends StatefulWidget {
  final Widget child;

  final VoidCallback onPressed;

  const WobblyButton({super.key, required this.child, required this.onPressed});

  @override
  State<WobblyButton> createState() => _WobblyButtonState();
}

class _WobblyButtonState extends State<WobblyButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        _controller.repeat();
      },
      onExit: (event) {
        _controller.stop(canceled: false);
      },
      child: RotationTransition(
        turns: _controller.drive(const _MySineTween(0.005)),
        child: GameButton(
          onPressed: widget.onPressed,
          child: widget.child,
        ),
      ),
    );
  }
}

class _MySineTween extends Animatable<double> {
  final double maxExtent;

  const _MySineTween(this.maxExtent);

  @override
  double transform(double t) {
    return sin(t * 2 * pi) * maxExtent;
  }
}
