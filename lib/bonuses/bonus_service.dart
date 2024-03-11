import 'dart:developer' as developer;

import 'package:battery_plus/battery_plus.dart';
import 'package:endless_runner/audio/sounds.dart';

import '../flame_game/whaley_world.dart';
import 'bonus_overlay.dart';

/// This service tracks player achievements such as completing rows with correct items
/// and awards bonuses accordingly. It also checks for special conditions like battery saver mode
/// to award additional bonuses. Bonuses are displayed to the player through overlays.
class BonusService {
  final WhaleyWorld _world;

  BonusService(this._world);

  final List<int> _rowsByCorrectItems = [];
  int highspeedCorrectItems = 0;
  int highspeedWrongItems = 0;

  final Map<BonusType, int> bonuses = {};

  final battery = Battery();

  void checkForFinishedRow() {
    final totalItems = _world.correctItems + _world.wrongItems;
    if (totalItems % 5 == 0) {
      final correctItemsBefore = _rowsByCorrectItems.isEmpty
          ? 0
          : _rowsByCorrectItems.reduce((value, element) => value + element);
      final newCorrectItems = _world.correctItems - correctItemsBefore;
      if (newCorrectItems == 5) {
        // Play Who Hoo sound when full row is completed:
        _world.game.audioController.playSfx(SfxType.whoHoo);
      }
      _rowsByCorrectItems.add(newCorrectItems);
      developer.log('Rows by correct items: $_rowsByCorrectItems');
    }
  }

  Future<void> assignLevelBonuses() async {
    bonuses[BonusType.fullRow] =
        _rowsByCorrectItems.where((row) => row == 5).length;

    bonuses[BonusType.fiveRows] = _countConsecutiveFives(_rowsByCorrectItems);

    if (highspeedWrongItems == 0 && highspeedCorrectItems > 0) {
      bonuses[BonusType.highspeed] = 1;
      // Play Who Hoo sound when highspeed is completed:
      _world.game.audioController.playSfx(SfxType.whoHoo);
    }

    try {
      final batterySaver = await battery.isInBatterySaveMode;
      if (batterySaver) {
        bonuses[BonusType.batterySaver] = 1;
      }
    } catch (e) {
      developer.log('Error checking battery saver mode: $e');
    }

    developer.log('Bonuses: $bonuses');

    for (var bonusType in BonusType.values) {
      if (bonuses[bonusType] == null || bonuses[bonusType] == 0) {
        continue;
      }
      _assignBonusPoints(bonusType);
      await _showBonusOverlay(bonusType);
    }

    bonuses.clear();
  }

  Future<void> _assignBonusPoints(BonusType bonusType) async {
    switch (bonusType) {
      case BonusType.fullRow:
        _world.scoreNotifier.value += 10;
        break;
      case BonusType.fiveRows:
        _world.scoreNotifier.value += 100;
        break;
      case BonusType.batterySaver:
        _world.scoreNotifier.value += 50;
        break;
      case BonusType.highspeed:
        _world.scoreNotifier.value += highspeedCorrectItems * 2;
        break;
    }
  }

  Future<void> _showBonusOverlay(BonusType bonusType) async {
    _world.game.overlays.add(bonusType.name);
    await Future.delayed(const Duration(seconds: 3), () {
      _world.game.overlays.remove(bonusType.name);
    });
  }

  int _countConsecutiveFives(List<int> numbers) {
    int count = 0;
    int consecutiveFives = 0;

    for (int number in numbers) {
      if (number == 5) {
        consecutiveFives++;
        if (consecutiveFives == 5) {
          count++;
          consecutiveFives = 0; // Reset to catch overlapping sequences.
        }
      } else {
        // Not a 5? Reset our consecutive fives counter.
        consecutiveFives = 0;
      }
    }

    return count;
  }
}
