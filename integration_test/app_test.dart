import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tripwise/main.dart' as app;
import 'package:flutter/material.dart';
import 'helpers/test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('verify splash screen and navigation flow', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify splash screen is shown
      expect(find.byType(Image), findsOneWidget);
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Verify we're on the main screen
      TestHelpers.expectSingleText('ListM');
      TestHelpers.expectSingleWidget(BottomNavigationBar);

      // Test navigation to All Items
      await TestHelpers.tapAndSettle(
        tester: tester,
        finder: find.text('All Items'),
      );
      TestHelpers.expectSingleText('All Items');

      // Verify FAB is present on All Items screen
      TestHelpers.expectSingleWidget(FloatingActionButton);

      // Tap FAB and verify input field appears
      await TestHelpers.tapAndSettle(
        tester: tester,
        finder: find.byType(FloatingActionButton),
      );
      TestHelpers.expectSingleWidget(TextField);

      // Test navigation back to Home
      await TestHelpers.tapAndSettle(
        tester: tester,
        finder: find.text('Home'),
      );
      TestHelpers.expectSingleText('ListM');
    });

    testWidgets('verify empty state messages', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Navigate to All Items
      await TestHelpers.tapAndSettle(
        tester: tester,
        finder: find.text('All Items'),
      );

      // Verify empty state message
      TestHelpers.expectSingleText('All Items Screen');
      expect(
        TestHelpers.findWidgetWithText(Center, 'Add your first item'),
        findsOneWidget,
      );
    });

    testWidgets('verify localization', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Verify default language texts are present
      TestHelpers.expectSingleText('Home');
      TestHelpers.expectSingleText('All Items');
    });
  });
}
