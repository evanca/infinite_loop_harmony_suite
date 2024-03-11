import 'package:endless_runner/achievements/achievement.dart';
import 'package:endless_runner/achievements/achievement_overlay.dart';
import 'package:endless_runner/achievements/google_wallet_service.dart';
import 'package:endless_runner/flame_game/whaley_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_wallet/google_wallet.dart';
import 'package:mocktail/mocktail.dart';

class FakeWhaleyGame extends Fake implements WhaleyGame {}

class MockGoogleWalletService extends Mock implements GoogleWalletService {}

void main() {
  final mockGame = FakeWhaleyGame();
  final mockGoogleWalletService = MockGoogleWalletService();

  group('AchievementOverlay', () {
    testWidgets('should render correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: AchievementOverlay(
            game: mockGame, achievementType: AchievementType.whaleBuddy),
      ));

      expect(find.byType(AchievementOverlay), findsOneWidget);
      expect(find.text('Achievement unlocked:'), findsOneWidget);
      expect(find.text('Close'), findsOneWidget);
    });

    testWidgets('should display Google Wallet button when available',
        (WidgetTester tester) async {
      when(() => mockGoogleWalletService.isAvailable())
          .thenAnswer((_) async => true);

      await tester.pumpWidget(MaterialApp(
        home: AchievementOverlay(
            game: mockGame,
            achievementType: AchievementType.whaleBuddy,
            googleWalletService: mockGoogleWalletService),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(GoogleWalletButton), findsOneWidget);
    });

    testWidgets('should not display Google Wallet button when not available',
        (WidgetTester tester) async {
      when(() => mockGoogleWalletService.isAvailable())
          .thenAnswer((_) async => false);

      await tester.pumpWidget(MaterialApp(
        home: AchievementOverlay(
            game: mockGame,
            achievementType: AchievementType.whaleBuddy,
            googleWalletService: mockGoogleWalletService),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(GoogleWalletButton), findsNothing);
    });
  });
}
