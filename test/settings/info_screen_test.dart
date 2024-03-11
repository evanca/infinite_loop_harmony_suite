import 'package:endless_runner/settings/info_screen.dart';
import 'package:endless_runner/settings/settings.dart';
import 'package:endless_runner/style/text_banner.dart';
import 'package:endless_runner/style/wobbly_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockSettingsController extends Mock implements SettingsController {}

void main() {
  final mockSettingsController = MockSettingsController();

  setUp(() {
    when(() => mockSettingsController.increasedContrast)
        .thenReturn(ValueNotifier<bool>(false));
  });

  group('InfoScreen', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        Provider<SettingsController>(
          create: (_) => mockSettingsController,
          child: MaterialApp(
            home: const InfoScreen(),
            onGenerateRoute: (settings) => MaterialPageRoute(
              builder: (context) => const InfoScreen(),
            ),
          ),
        ),
      );

      expect(find.byType(TextBanner), findsOneWidget);
      expect(find.text('How to play'), findsOneWidget);

      final scrollView = find.byType(Scrollable);
      await tester.drag(scrollView, const Offset(0, -500));
      await tester.pumpAndSettle();

      expect(find.text('RED BIN: Hazardous waste'), findsOneWidget);
      expect(find.text('YELLOW BIN: Recyclable packaging'), findsOneWidget);

      await tester.drag(scrollView, const Offset(0, -800));
      await tester.pumpAndSettle();

      expect(find.text('GREEN BIN: Biodegradable waste'), findsOneWidget);
      expect(find.text('BLUE BIN: Paper and cardboard'), findsOneWidget);

      await tester.drag(scrollView, const Offset(0, -900));
      await tester.pumpAndSettle();
      expect(find.text('BLACK BIN: General waste'), findsOneWidget);

      expect(find.byType(WobblyButton), findsOneWidget);
      expect(find.text('Back'), findsOneWidget);
    });
  });
}
