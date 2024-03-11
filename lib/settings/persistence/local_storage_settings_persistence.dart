import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import 'settings_persistence.dart';

/// An implementation of [SettingsPersistence] that uses
/// `package:shared_preferences`.
class LocalStorageSettingsPersistence extends SettingsPersistence {
  final Future<SharedPreferences> instanceFuture =
      SharedPreferences.getInstance();

  @override
  Future<void> saveUserId(String userId) async {
    final prefs = await instanceFuture;
    await prefs.setString('userId', userId);
  }

  @override
  Future<String> getUserId() async {
    final prefs = await instanceFuture;
    return prefs.getString('userId') ?? '';
  }

  @override
  Future<bool> getAudioOn({required bool defaultValue}) async {
    final prefs = await instanceFuture;
    return prefs.getBool('audioOn') ?? defaultValue;
  }

  @override
  Future<bool> getMusicOn({required bool defaultValue}) async {
    final prefs = await instanceFuture;
    return prefs.getBool('musicOn') ?? defaultValue;
  }

  @override
  Future<String> getPlayerName() async {
    final prefs = await instanceFuture;
    return prefs.getString('playerName') ?? Constants.defaultUserName;
  }

  @override
  Future<bool> getSoundsOn({required bool defaultValue}) async {
    final prefs = await instanceFuture;
    return prefs.getBool('soundsOn') ?? defaultValue;
  }

  @override
  Future<void> saveAudioOn(bool value) async {
    final prefs = await instanceFuture;
    await prefs.setBool('audioOn', value);
  }

  @override
  Future<void> saveMusicOn(bool value) async {
    final prefs = await instanceFuture;
    await prefs.setBool('musicOn', value);
  }

  @override
  Future<void> savePlayerName(String value) async {
    final prefs = await instanceFuture;
    await prefs.setString('playerName', value);
  }

  @override
  Future<void> saveSoundsOn(bool value) async {
    final prefs = await instanceFuture;
    await prefs.setBool('soundsOn', value);
  }

  @override
  Future<bool> getIntroSeen() async {
    final prefs = await instanceFuture;
    return prefs.getBool('introSeen') ?? false;
  }

  @override
  Future<void> saveIntroSeen() async {
    final prefs = await instanceFuture;
    await prefs.setBool('introSeen', true);
  }

  @override
  Future<bool> getIncreasedContrast() async {
    final prefs = await instanceFuture;
    return prefs.getBool('increasedContrast') ?? false;
  }

  @override
  Future<void> saveIncreasedContrast(bool value) async {
    final prefs = await instanceFuture;
    await prefs.setBool('increasedContrast', value);
  }
}
