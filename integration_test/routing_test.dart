import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:listm/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'helpers/test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Routing tests', () {
    testWidgets('verify navigation through go_router', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Verify initial route (after splash)
      expect(find.text('ListM'), findsOneWidget);

      // Navigate to All Items and verify
      await TestHelpers.tapAndSettle(
        tester: tester,
        finder: find.text('All Items'),
      );
      expect(find.text('All Items'), findsOneWidget);

      // Navigate back to home and verify
      await TestHelpers.tapAndSettle(
        tester: tester,
        finder: find.text('Home'),
      );
      expect(find.text('ListM'), findsOneWidget);
    });

    testWidgets('verify deep linking navigation', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Navigate to specific list screen
      await TestHelpers.tapAndSettle(
        tester: tester,
        finder: find.text('All Items'),
      );
      expect(find.text('All Items'), findsOneWidget);

      // Test back navigation
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('ListM'), findsOneWidget);
    });

    testWidgets('verify bottom navigation', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Verify bottom navigation bar is present
      expect(find.byType(BottomNavigationBar), findsOneWidget);

      // Test navigation to All Items
      await TestHelpers.tapAndSettle(
        tester: tester,
        finder: find.text('All Items'),
      );
      expect(find.text('All Items'), findsOneWidget);

      // Test navigation back to Home
      await TestHelpers.tapAndSettle(
        tester: tester,
        finder: find.text('Home'),
      );
      expect(find.text('ListM'), findsOneWidget);
    });
  });
}
