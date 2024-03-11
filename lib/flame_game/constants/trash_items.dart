import 'package:endless_runner/flame_game/components/bin.dart';
import 'package:endless_runner/gen/assets.gen.dart';

class TrashItems {
  TrashItems._();

  static Map<BinColor, List<AssetGenImage>> byBinColor = {
    BinColor.red: [
      Assets.images.redCleaner,
      Assets.images.redDanger,
      Assets.images.redOil,
      Assets.images.redPhone,
      Assets.images.redThermometer,
    ],
    BinColor.yellow: [
      Assets.images.yellowBottle,
      Assets.images.yellowCan,
      Assets.images.yellowPot,
      Assets.images.yellowTin,
      Assets.images.yellowTray,
    ],
    BinColor.green: [
      Assets.images.greenApple,
      Assets.images.greenEggshell,
      Assets.images.greenLeaves,
      Assets.images.greenNutshell,
      Assets.images.greenBread,
    ],
    BinColor.blue: [
      Assets.images.blueBox,
      Assets.images.blueCarton,
      Assets.images.blueNewspaper,
      Assets.images.bluePaper,
      Assets.images.blueTowels,
    ],
    BinColor.black: [
      Assets.images.blackChips,
      Assets.images.blackCup,
      Assets.images.blackDish,
      Assets.images.blackShoe,
      Assets.images.blackSwabs,
    ],
  };

  static Map<AssetGenImage, String> labels = {
    Assets.images.redCleaner: 'Cleaning product',
    Assets.images.redDanger: 'Paint can',
    Assets.images.redOil: 'Motor oil',
    Assets.images.redPhone: 'Old cell phone',
    Assets.images.redThermometer: 'Thermometer',
    Assets.images.yellowBottle: 'Plastic bottle',
    Assets.images.yellowCan: 'Soda can',
    Assets.images.yellowPot: 'Metal pot',
    Assets.images.yellowTin: 'Tin can',
    Assets.images.yellowTray: 'Foil tray',
    Assets.images.greenApple: 'Apple',
    Assets.images.greenEggshell: 'Eggshells',
    Assets.images.greenLeaves: 'Leaves',
    Assets.images.greenNutshell: 'Nutshells',
    Assets.images.greenBread: 'Expired bread',
    Assets.images.blueBox: 'Cardboard box',
    Assets.images.blueCarton: 'Postage box',
    Assets.images.blueNewspaper: 'Old newspaper',
    Assets.images.bluePaper: 'Paper',
    Assets.images.blueTowels: 'Paper towels',
    Assets.images.blackChips: 'Chip bag',
    Assets.images.blackCup: 'Coffee cup',
    Assets.images.blackDish: 'Broken dish',
    Assets.images.blackShoe: 'Old shoe',
    Assets.images.blackSwabs: 'Cotton swabs',
  };
}
