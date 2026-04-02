import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class TestHelpers {
  /// Finds a widget by key and scrolls until it's visible
  static Future<void> scrollUntilVisible({
    required WidgetTester tester,
    required Key key,
    required Finder scrollable,
  }) async {
    await tester.scrollUntilVisible(
      find.byKey(key),
      500.0,
      scrollable: scrollable,
    );
  }

  /// Enters text in a TextField
  static Future<void> enterText({
    required WidgetTester tester,
    required String text,
    Key? textFieldKey,
  }) async {
    await tester.enterText(
      textFieldKey != null ? find.byKey(textFieldKey) : find.byType(TextField),
      text,
    );
    await tester.pump();
  }

  /// Taps a widget and waits for animations to complete
  static Future<void> tapAndSettle({
    required WidgetTester tester,
    required Finder finder,
  }) async {
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  /// Verifies if a SnackBar with specific text is displayed
  static void expectSnackBarWithText(String text) {
    expect(
      find.descendant(
        of: find.byType(SnackBar),
        matching: find.text(text),
      ),
      findsOneWidget,
    );
  }

  /// Verifies if a specific text appears exactly once
  static void expectSingleText(String text) {
    expect(find.text(text), findsOneWidget);
  }

  /// Verifies if a specific widget appears exactly once
  static void expectSingleWidget(Type widgetType) {
    expect(find.byType(widgetType), findsOneWidget);
  }

  /// Find a widget of specific type containing specific text
  static Finder findWidgetWithText(Type widgetType, String text) {
    return find.descendant(
      of: find.byType(widgetType),
      matching: find.text(text),
    );
  }
}
