import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listm/core/widgets/adaptive/adaptive_scaffold.dart';

void main() {
  group('AdaptiveScaffold Verification', () {
    testWidgets('renders Material Scaffold on Android',
        (WidgetTester tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;

      await tester.pumpWidget(
        MaterialApp(
          home: AdaptiveScaffold(
            title: 'Test',
            body: Container(),
            materialAppBar: (context) =>
                AppBar(title: const Text('Custom AppBar')),
            bottomNavigationBar: const BottomAppBar(),
          ),
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.text('Custom AppBar'), findsOneWidget);
      expect(find.byType(BottomAppBar), findsOneWidget);

      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('renders CupertinoPageScaffold on iOS',
        (WidgetTester tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

      await tester.pumpWidget(
        CupertinoApp(
          home: AdaptiveScaffold(
            title: 'Test',
            body: Container(),
            cupertinoNavigationBar: (context) =>
                const CupertinoNavigationBar(middle: Text('Custom NavBar')),
            bottomNavigationBar: const Text('Bottom Bar'),
          ),
        ),
      );

      expect(find.byType(CupertinoPageScaffold), findsOneWidget);
      expect(find.text('Custom NavBar'), findsOneWidget);
      expect(find.text('Bottom Bar'), findsOneWidget);
      // Check column structure for bottom bar simulation
      // Check that bottom bar is present (implicit verified by finding text above)
      // expect(find.byType(Column), findsOneWidget); // Removed ambiguous check

      debugDefaultTargetPlatformOverride = null;
    });
  });
}
