import 'package:flutter/material.dart';

import '../../gen/assets.gen.dart';
import '../../style/gaps.dart';
import '../../style/palette.dart';

/// Enumerates the types of bonuses available in the game, each associated with a specific title.
///
/// - `fullRow`: Represents a bonus awarded for completing a row with correctly sorted items.
/// - `fiveRows`: Indicates a bonus for achieving five consecutive rows of correct sorting.
/// - `batterySaver`: Denotes a special bonus awarded when the game is played in battery saver mode,
///   emphasizing eco-friendly gaming practices.
enum BonusType {
  fullRow('FULL ROW'),
  fiveRows('FIVE ROWS'),
  batterySaver('BATTERY\nSAVER ON'),
  highspeed('HIGH SPEED');

  final String title;

  const BonusType(this.title);
}

/// Displays an animated overlay for bonus achievements in the game.
///
/// This widget animates a bonus achievement's title and image, zooming them into view
/// to highlight the player's accomplishment. It supports different types of bonuses,
/// indicated by the `bonusType` parameter, and scales the overlay with a spring-like
/// effect to capture the player's attention. The `count` parameter is used for bonuses
/// that can be quantified, enhancing the feedback for player achievements.
class BonusOverlay extends StatefulWidget {
  const BonusOverlay({
    required this.bonusType,
    required this.count,
    super.key,
  });

  /// The type of bonus being awarded, determining the text and image displayed.
  final BonusType bonusType;

  /// The quantity of the bonus, applicable to quantifiable achievements.
  final int count;

  @override
  State<BonusOverlay> createState() => _BonusOverlayState();
}

class _BonusOverlayState extends State<BonusOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scaleAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut, // This curve creates a spring-like effect
    ));

    // Start the animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: Center(
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return ScaleTransition(
              scale: _scaleAnimation,
              child: child,
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              title(context, widget.bonusType, widget.count),
              Gaps.verticalM,
              Flexible(child: image(widget.bonusType)),
            ],
          ),
        ),
      ),
    );
  }

  Widget title(BuildContext context, BonusType bonusType, int count) {
    final foreground = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..color = Palette.bannerBackground;

    String text = bonusType.title;

    if (bonusType != BonusType.batterySaver &&
        bonusType != BonusType.highspeed) {
      text += ' x$count';
    }

    return Semantics(
      label: text,
      child: Stack(
        children: <Widget>[
          Text(
            text,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  foreground: foreground,
                ),
            textAlign: TextAlign.center,
          ),
          Text(
            text,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget image(BonusType bonusType) {
    String semanticLabel;
    Widget child;
    switch (bonusType) {
      case BonusType.fullRow:
        semanticLabel = 'Full row bonus badge';
        child = Assets.images.bonusFullRow.image(
          semanticLabel: semanticLabel,
          scale: 0.75,
          filterQuality: FilterQuality.none,
        );
        break;
      case BonusType.fiveRows:
        semanticLabel = 'Five rows bonus badge';
        child = Assets.images.bonusFiveRows.image(
          semanticLabel: semanticLabel,
          scale: 0.75,
          filterQuality: FilterQuality.none,
        );
        break;
      case BonusType.batterySaver:
        semanticLabel = 'Battery saver bonus badge';
        child = Assets.images.bonusBattery.image(
          semanticLabel: semanticLabel,
          scale: 0.75,
          filterQuality: FilterQuality.none,
        );
        break;
      case BonusType.highspeed:
        semanticLabel = 'High speed bonus badge';
        child = Assets.images.bonusHighspeed.image(
          semanticLabel: semanticLabel,
          scale: 0.75,
          filterQuality: FilterQuality.none,
        );
        break;
    }
    return Semantics(
      image: true,
      child: child,
    );
  }
}
