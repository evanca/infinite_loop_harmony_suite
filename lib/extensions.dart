import 'gen/assets.gen.dart';

extension FilenameGetter on AssetGenImage {
  String getFilename() {
    return path.replaceAll('assets/images/', '');
  }
}

extension MusicPathFormatting on String {
  String formatPath() {
    return replaceAll('assets/', '');
  }
}
