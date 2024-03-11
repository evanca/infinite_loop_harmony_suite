import 'package:endless_runner/leaderboard/persistence/leaderboard_persistence.dart';
import 'package:endless_runner/level_selection/level_badge.dart';
import 'package:endless_runner/level_selection/level_selection_screen.dart';
import 'package:endless_runner/player_progress/level_progress.dart';
import 'package:endless_runner/player_progress/player_progress.dart';
import 'package:endless_runner/settings/settings.dart';
import 'package:endless_runner/style/text_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockSettingsController extends Mock implements SettingsController {}

class MockPlayerProgress extends Mock implements PlayerProgress {}

class FakeLeaderboardPersistence extends Fake
    implements LeaderboardPersistence {}

void main() {
  final mockSettingsController = MockSettingsController();
  final mockPlayerProgress = MockPlayerProgress();

  setUp(() {
    when(() => mockSettingsController.increasedContrast)
        .thenReturn(ValueNotifier<bool>(false));

    when(() => mockPlayerProgress.levels).thenReturn({
      1: LevelProgress.initial(1),
      2: LevelProgress.initial(2),
      3: LevelProgress.initial(3),
      4: LevelProgress.initial(4),
      5: LevelProgress.initial(5),
    });
  });

  group('LevelSelectionScreen', () {
    testWidgets('renders correctly with level badges and navigation buttons',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              Provider<SettingsController>.value(value: mockSettingsController),
              ChangeNotifierProvider<PlayerProgress>(
                create: (_) => mockPlayerProgress,
              ),
            ],
            child: const LevelSelectionScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(TextBanner), findsOneWidget);
      expect(find.text('Select level'), findsOneWidget);

      expect(
          find.byWidgetPredicate((widget) =>
              widget is LevelBadge &&
              widget.levelProgress.levelNumber <= 5 &&
              !widget.locked),
          findsNWidgets(5));

      expect(
          find.byWidgetPredicate(
              (widget) => widget is LevelBadge && widget.locked),
          findsWidgets);

      expect(find.text('Back'), findsOneWidget);
      expect(find.text('Leaderboard'), findsOneWidget);
      expect(find.text('Info'), findsOneWidget);
    });
  });
}
