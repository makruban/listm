import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tripwise/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'helpers/test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Platform-specific tests', () {
    testWidgets('verify correct app structure based on platform',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      if (Platform.isIOS) {
        // Verify iOS-specific widgets
        TestHelpers.expectSingleWidget(CupertinoApp);
        TestHelpers.expectSingleWidget(CupertinoNavigationBar);
        expect(find.byType(CupertinoButton), findsWidgets);
      } else {
        // Verify Material-specific widgets
        TestHelpers.expectSingleWidget(MaterialApp);
        TestHelpers.expectSingleWidget(AppBar);
        expect(find.byType(FloatingActionButton), findsOneWidget);
      }
    });

    testWidgets('verify platform-specific add item behavior', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Navigate to All Items
      await TestHelpers.tapAndSettle(
        tester: tester,
        finder: find.text('All Items'),
      );

      if (Platform.isIOS) {
        // Test iOS-specific add button
        final addButton = find.byIcon(CupertinoIcons.add);
        expect(addButton, findsOneWidget);
        await TestHelpers.tapAndSettle(
          tester: tester,
          finder: addButton,
        );
      } else {
        // Test Material FAB
        final fab = find.byType(FloatingActionButton);
        expect(fab, findsOneWidget);
        await TestHelpers.tapAndSettle(
          tester: tester,
          finder: fab,
        );
      }

      // Verify input field appears on both platforms
      expect(
        Platform.isIOS
            ? find.byType(CupertinoTextField)
            : find.byType(TextField),
        findsOneWidget,
      );
    });
  });
}
