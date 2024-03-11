import 'package:flutter/material.dart';

class Gaps {
  Gaps._();

  static const verticalS = ExcludeSemantics(child: SizedBox(height: 8));
  static const verticalM = ExcludeSemantics(child: SizedBox(height: 16));
  static const verticalL = ExcludeSemantics(child: SizedBox(height: 24));
  static const verticalXL = ExcludeSemantics(child: SizedBox(height: 32));
  static const verticalXXL = ExcludeSemantics(child: SizedBox(height: 42));

  static const horizontalS = ExcludeSemantics(child: SizedBox(width: 8));
  static const horizontalM = ExcludeSemantics(child: SizedBox(width: 16));
}
