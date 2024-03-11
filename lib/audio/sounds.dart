List<String> soundTypeToFilename(SfxType type) {
  switch (type) {
    case SfxType.ohNo:
      return const [
        'ohNo.m4a',
      ];
    case SfxType.whoHoo:
      return const [
        'whoHoo.m4a',
      ];
    case SfxType.buttonTap:
      return const [
        'click1.mp3',
        'click2.mp3',
        'click3.mp3',
        'click4.mp3',
      ];
  }
}

/// Allows control over loudness of different SFX types.
double soundTypeToVolume(SfxType type) {
  switch (type) {
    case SfxType.ohNo:
    case SfxType.whoHoo:
      return 0.4;
    case SfxType.buttonTap:
      return 1.0;
  }
}

enum SfxType {
  ohNo,
  whoHoo,
  buttonTap,
}
