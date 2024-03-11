// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';

import 'persistence/local_storage_settings_persistence.dart';
import 'persistence/settings_persistence.dart';

/// An class that holds settings like [playerName] or [musicOn],
/// and saves them to an injected persistence store.
class SettingsController {
  static final _log = Logger('SettingsController');

  /// The persistence store that is used to save settings.
  final SettingsPersistence _store;

  /// Whether or not the audio is on at all. This overrides both music
  /// and sounds (sfx).
  ///
  /// This is an important feature especially on mobile, where players
  /// expect to be able to quickly mute all the audio. Having this as
  /// a separate flag (as opposed to some kind of {off, sound, everything}
  /// enum) means that the player will not lose their [soundsOn] and
  /// [musicOn] preferences when they temporarily mute the game.
  ValueNotifier<bool> audioOn = ValueNotifier(true);

  /// The player's name. Used for things like high score lists.
  ValueNotifier<String> playerName = ValueNotifier('Player');

  /// Whether or not the sound effects (sfx) are on.
  ValueNotifier<bool> soundsOn = ValueNotifier(true);

  /// Whether or not the music is on.
  ValueNotifier<bool> musicOn = ValueNotifier(true);

  /// Whether or not contrast is increased.
  ValueNotifier<bool> increasedContrast = ValueNotifier(false);

  /// Whether or not the intro has been seen.
  ValueNotifier<bool?> introSeen = ValueNotifier(null);

  /// User ID for the current player.
  String? userId;

  /// Creates a new instance of [SettingsController] backed by [store].
  ///
  /// By default, settings are persisted using [LocalStorageSettingsPersistence]
  /// (i.e. NSUserDefaults on iOS, SharedPreferences on Android or
  /// local storage on the web).
  SettingsController({SettingsPersistence? store})
      : _store = store ?? LocalStorageSettingsPersistence() {
    _maybeGenerateUserId();
    _loadStateFromPersistence();
  }

  void setPlayerName(String name) {
    playerName.value = name;
    _store.savePlayerName(playerName.value);
  }

  void toggleAudioOn() {
    bool value = !audioOn.value;

    audioOn.value = value;
    _store.saveAudioOn(value);

    musicOn.value = value;
    soundsOn.value = value;
    _store.saveMusicOn(value);
    _store.saveSoundsOn(value);
  }

  void toggleMusicOn() {
    musicOn.value = !musicOn.value;
    _store.saveMusicOn(musicOn.value);
  }

  void toggleSoundsOn() {
    soundsOn.value = !soundsOn.value;
    _store.saveSoundsOn(soundsOn.value);
  }

  void toggleIncreasedContrast() {
    increasedContrast.value = !increasedContrast.value;
    _store.saveIncreasedContrast(increasedContrast.value);
  }

  void setIntroSeen() {
    introSeen.value = true;
    _store.saveIntroSeen();
  }

  Future<bool> getIntroSeen() async {
    return _store.getIntroSeen();
  }

  /// Asynchronously loads values from the injected persistence store.
  Future<void> _loadStateFromPersistence() async {
    final loadedValues = await Future.wait([
      _store.getAudioOn(defaultValue: true).then((value) {
        if (kIsWeb) {
          // On the web, sound can only start after user interaction, so
          // we start muted there on every game start.
          return audioOn.value = false;
        }
        // On other platforms, we can use the persisted value.
        return audioOn.value = value;
      }),
      _store.getIntroSeen().then((value) => introSeen.value = value),
      _store
          .getSoundsOn(defaultValue: true)
          .then((value) => soundsOn.value = value),
      _store
          .getMusicOn(defaultValue: true)
          .then((value) => musicOn.value = value),
      _store.getPlayerName().then((value) => playerName.value = value),
      _store
          .getIncreasedContrast()
          .then((value) => increasedContrast.value = value),
    ]);

    _log.fine(() => 'Loaded settings: $loadedValues');
  }

  Future<void> _maybeGenerateUserId() async {
    userId = await _store.getUserId();
    if (userId!.isEmpty) {
      _log.info('No user ID found, generating a new one.');
      final String userId = const Uuid().v4();
      await _store.saveUserId(userId);
    }
  }
}
