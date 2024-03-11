import 'package:endless_runner/gen/assets.gen.dart';

List<Song> songs = [
  Song(Assets.music.summerPark, 'Summer Park', artist: 'Scribe'),
  Song(Assets.music.longAwayHome, 'Long Away Home', artist: 'nene'),
];

class Song {
  final String filename;

  final String name;

  final String? artist;

  const Song(this.filename, this.name, {this.artist});

  @override
  String toString() => 'Song<$filename>';
}
