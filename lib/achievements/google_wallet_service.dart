import 'dart:developer';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:endless_runner/achievements/achievement.dart';
import 'package:flutter/services.dart';
import 'package:google_wallet/google_wallet.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import '../env.dart';

class GoogleWalletService {
  final googleWallet = GoogleWallet();

  static const owner = 'whaleys-bins-wallet-account@api-8846652454458576997'
      '-120023.iam.gserviceaccount.com';

  static const issuerId = '3388000000022311726';

  static const className = 'WhaleyAchievement';

  static const cardTitle = 'Whaleys Bins Waste Sorting';

  static const backgroundColor = '#113E61';

  Future<bool?> isAvailable() async {
    return await googleWallet.isAvailable();
  }

  void savePass(Achievement achievement) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final String objectId = const Uuid().v4();

    final String payload = '''
{
   "iss":"$owner",
   "aud":"google",
   "typ":"savetowallet",
   "iat":"$timestamp",
   "origins":[
      
   ],
   "payload":{
      "genericObjects":[
         {
            "id":"$issuerId.$objectId",
            "classId":"$issuerId.$className",
            "genericType":"GENERIC_TYPE_UNSPECIFIED",
            "hexBackgroundColor":"$backgroundColor",
            "heroImage":{
               "sourceUri":{
                  "uri":"${achievement.imageUrl}"
               },
               "contentDescription":{
                  "defaultValue":{
                     "language":"en-US",
                     "value":"Background image with aquatic elements"
                  }
               }
            },
            "cardTitle":{
               "defaultValue":{
                  "language":"en",
                  "value":"$cardTitle"
               }
            },
            "header":{
               "defaultValue":{
                  "language":"en",
                  "value":"${achievement.title}"
               }
            },
            "subheader":{
               "defaultValue":{
                  "language":"en",
                  "value":"${achievement.description}"
               }
            }
         }
      ]
   }
}
''';

    // Load service account key
    const String key = Env.googleServiceAccountKey;

    // Create the JWT
    final jwt = JWT(payload, header: {'alg': 'RS256', 'typ': 'JWT'});

    // Sign the JWT with RS256 and service account's private key
    final token = jwt.sign(RSAPrivateKey(key), algorithm: JWTAlgorithm.RS256);

    // Save a pass to Google Wallet
    try {
      if (await googleWallet.isAvailable() == true) {
        final saved = await googleWallet.savePassesJwt(token);
        log('Pass saved to Google Wallet: $saved', name: 'GoogleWalletService');
      } else {
        // Wallet unavailable,
        // fall back to saving pass via web: "https://pay.google.com/gp/v/save/${jwt}"
        log('Google Wallet is not available', name: 'GoogleWalletService');

        final String url = 'https://pay.google.com/gp/v/save/$token';
        launchUrl(Uri.parse(url));
      }
    } on PlatformException catch (e) {
      log('Failed to save pass to Google Wallet: $e',
          name: 'GoogleWalletService');
    }
  }
}
