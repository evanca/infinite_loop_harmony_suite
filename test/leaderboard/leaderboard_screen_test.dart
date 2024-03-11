import 'package:endless_runner/leaderboard/leaderboard_entry.dart';
import 'package:endless_runner/leaderboard/leaderboard_screen.dart';
import 'package:endless_runner/leaderboard/persistence/leaderboard_persistence.dart';
import 'package:endless_runner/settings/settings.dart';
import 'package:endless_runner/style/text_banner.dart';
import 'package:endless_runner/style/wobbly_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockLeaderboardPersistence extends Mock
    implements LeaderboardPersistence {}

class MockSettingsController extends Mock implements SettingsController {}

void main() {
  final mockLeaderboardPersistence = MockLeaderboardPersistence();
  final mockSettingsController = MockSettingsController();
  final leaderboardEntries = [
    LeaderboardEntry(
        userId: '1', name: 'Player 1', overallScore: 100, achievements: []),
    LeaderboardEntry(
        userId: '2', name: 'Player 2', overallScore: 200, achievements: []),
  ];

  setUp(() {
    when(() => mockSettingsController.increasedContrast)
        .thenReturn(ValueNotifier<bool>(false));
    when(() => mockLeaderboardPersistence.getLeaderboard())
        .thenAnswer((_) async => leaderboardEntries);
    when(() => mockSettingsController.userId).thenReturn('1');
  });

  group('LeaderboardScreen', () {
    testWidgets(
        'renders correctly with leaderboard entries and navigation button',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<SettingsController>(create: (_) => mockSettingsController),
          ],
          child: MaterialApp(
            home: LeaderboardScreen(
                leaderboardPersistence: mockLeaderboardPersistence),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(TextBanner), findsOneWidget);
      expect(find.text('Leaderboard'), findsOneWidget);

      expect(find.text('Player 1'), findsOneWidget);

      expect(find.textContaining('100'), findsOneWidget);
      expect(find.text('Player 2'), findsOneWidget);
      expect(find.textContaining('200'), findsOneWidget);

      expect(find.byType(WobblyButton), findsOneWidget);
      expect(find.text('Back'), findsOneWidget);
    });
  });
}
