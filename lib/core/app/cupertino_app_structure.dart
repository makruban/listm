import 'package:flutter/cupertino.dart';
import 'package:listm/core/resources/theme_manager/cupertino_theme_manager.dart';
import 'package:listm/presentation/screens/main_screen.dart';
import 'package:listm/presentation/screens/splash_screen.dart';

class CupertinoAppStructure extends StatelessWidget {
  const CupertinoAppStructure({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'ListM',
      theme: CupertinoThemeManager.getCupertinoAppTheme(),
      home: const SplashScreen(),
      routes: {
        '/home': (context) => const MainScreen(),
      },
    );
  }
}
