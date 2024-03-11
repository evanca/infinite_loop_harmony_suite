import 'package:endless_runner/settings/settings.dart';
import 'package:endless_runner/style/screen_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockSettingsController extends Mock implements SettingsController {}

void main() {
  group('ScreenBackground', () {
    late MockSettingsController mockSettingsController;

    setUp(() {
      mockSettingsController = MockSettingsController();
    });

    testWidgets('displays with increased contrast when enabled',
        (WidgetTester tester) async {
      when(() => mockSettingsController.increasedContrast)
          .thenReturn(ValueNotifier<bool>(true));

      await tester.pumpWidget(
        MaterialApp(
          home: Provider<SettingsController>(
            create: (_) => mockSettingsController,
            child: const ScreenBackground(child: Text('Child Widget')),
          ),
        ),
      );

      expect(find.byType(ScreenBackground), findsOneWidget);
      expect(find.byType(Icon), findsOneWidget);
      expect(find.byIcon(Icons.dark_mode), findsOneWidget);
      expect(find.text('Child Widget'), findsOneWidget);
    });

    testWidgets('displays without increased contrast when disabled',
        (WidgetTester tester) async {
      when(() => mockSettingsController.increasedContrast)
          .thenReturn(ValueNotifier<bool>(false));

      await tester.pumpWidget(
        MaterialApp(
          home: Provider<SettingsController>(
            create: (_) => mockSettingsController,
            child: const ScreenBackground(child: Text('Child Widget')),
          ),
        ),
      );

      expect(find.byType(ScreenBackground), findsOneWidget);
      expect(find.byType(Icon), findsOneWidget);
      expect(find.byIcon(Icons.dark_mode_outlined), findsOneWidget);
      expect(find.text('Child Widget'), findsOneWidget);
    });
  });
}
