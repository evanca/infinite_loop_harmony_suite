import 'package:endless_runner/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class YouWinBanner extends StatelessWidget {
  final bool isParentPortrait;

  const YouWinBanner({super.key, required this.isParentPortrait});

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Container(
          padding: const EdgeInsets.only(bottom: 8),
          alignment: Alignment.center,
          height: isParentPortrait ? 64 : 80,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: Assets.images.banner.provider(),
            ),
          ),
          child: Text(
            'YOU WIN!',
            style: isParentPortrait
                ? Theme.of(context).textTheme.titleMedium
                : Theme.of(context).textTheme.bodyLarge,
          )),
    );
  }
}
