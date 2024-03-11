import 'package:flutter/material.dart';

/// A widget builder that provides context and orientation information for the area.
typedef ResponsiveAreaBuilder = Widget Function(
    BuildContext context, bool isPortrait);

/// A widget that makes it easy to create a screen with a square-ish
/// main area, a smaller menu area, and a small area for a message on top.
/// It works in both orientations on mobile- and tablet-sized screens.
class ResponsiveScreen extends StatelessWidget {
  /// Builder for the main area of the screen, which adapts based on screen orientation.
  final ResponsiveAreaBuilder squarishMainAreaBuilder;

  /// The second-largest area after [squarishMainArea]. It can be narrow
  /// or wide.
  final Widget rectangularMenuArea;

  /// Builder for the top area of the screen, which adapts based on screen orientation.
  /// orientation.
  final ResponsiveAreaBuilder? topMessageAreaBuilder;

  const ResponsiveScreen({
    required this.squarishMainAreaBuilder,
    required this.rectangularMenuArea,
    this.topMessageAreaBuilder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // This widget wants to fill the whole screen.
        final size = constraints.biggest;
        final padding = EdgeInsets.all(size.shortestSide / 30);
        final isPortrait = size.height >= size.width;
        if (isPortrait) {
          return _buildMainColumn(context,
              padding: padding, isPortrait: isPortrait);
        } else {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Expanded(
                flex: 2,
                child: _buildMainColumn(context,
                    padding: padding, isPortrait: isPortrait),
              ),
              const Spacer(),
            ],
          );
        }
      },
    );
  }

  Widget _buildMainColumn(BuildContext context,
      {required EdgeInsets padding, required bool isPortrait}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SafeArea(
          bottom: false,
          child: Padding(
            padding: padding,
            child: topMessageAreaBuilder?.call(context, isPortrait),
          ),
        ),
        Expanded(
          child: SafeArea(
              top: false,
              bottom: false,
              minimum:
                  EdgeInsets.symmetric(horizontal: padding.horizontal * 1.05),
              child: squarishMainAreaBuilder(context, isPortrait)),
        ),
        SafeArea(
          top: false,
          maintainBottomViewPadding: true,
          child: Padding(
            padding:
                isPortrait ? EdgeInsets.all(padding.horizontal / 3) : padding,
            child: Center(
              child: rectangularMenuArea,
            ),
          ),
        ),
      ],
    );
  }
}
