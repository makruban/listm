import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tripwise/main.dart' as app;
import 'package:tripwise/l10n/app_localizations.dart';
import 'helpers/test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Localization tests', () {
    testWidgets('verify default language strings', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Verify navigation labels
      TestHelpers.expectSingleText('Home');
      TestHelpers.expectSingleText('All Items');

      // Navigate to All Items screen
      await TestHelpers.tapAndSettle(
        tester: tester,
        finder: find.text('All Items'),
      );

      // Verify screen title
      TestHelpers.expectSingleText('All Items');
    });

    testWidgets('verify app adapts to system locale', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Change test device locale to German
      await tester.binding.setLocale('de', 'DE');
      await tester.pumpAndSettle();

      // Verify German translations
      TestHelpers.expectSingleText('Startseite');
      TestHelpers.expectSingleText('Alle Artikel');

      // Reset locale
      await tester.binding.setLocale('en', 'US');
      await tester.pumpAndSettle();
    });

    testWidgets('verify platform-specific localizations', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      if (Platform.isIOS) {
        // Verify iOS-specific widgets with localized text
        expect(find.byType(CupertinoNavigationBar), findsOneWidget);
        TestHelpers.expectSingleWidget(CupertinoApp);
      } else {
        // Verify Material-specific widgets with localized text
        expect(find.byType(AppBar), findsOneWidget);
        TestHelpers.expectSingleWidget(MaterialApp);
      }

      // Common localized elements should be present regardless of platform
      expect(
        find.byType(Platform.isIOS ? CupertinoButton : TextButton),
        findsWidgets,
      );
    });

    testWidgets('verify error messages are localized', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Navigate to All Items
      await TestHelpers.tapAndSettle(
        tester: tester,
        finder: find.text('All Items'),
      );

      // Try to add an empty item (should show localized error)
      await TestHelpers.tapAndSettle(
        tester: tester,
        finder: find.byType(FloatingActionButton),
      );

      // Verify error message is shown in current locale
      expect(
        find.text('Please enter an item name'),
        findsOneWidget,
      );
    });
  });
}
