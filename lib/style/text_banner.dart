import 'package:endless_runner/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class TextBanner extends StatelessWidget {
  final bool isParentPortrait;
  final String title;

  const TextBanner(
      {super.key, required this.isParentPortrait, required this.title});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: 'Banner with title "$title"',
      child: Container(
          padding: const EdgeInsets.only(bottom: 8),
          alignment: Alignment.center,
          height: isParentPortrait ? 60 : 80,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: Assets.images.banner.provider(),
            ),
          ),
          child: ExcludeSemantics(
            child: Text(
              title,
              style: isParentPortrait
                  ? Theme.of(context).textTheme.bodyMedium
                  : Theme.of(context).textTheme.bodyLarge,
            ),
          )),
    );
  }
}
