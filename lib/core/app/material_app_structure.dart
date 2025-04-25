import 'package:flutter/material.dart';
import 'package:listm/core/resources/theme_manager/material_theme_manager.dart';
import 'package:listm/presentation/screens/main_screen.dart';
import 'package:listm/presentation/screens/splash_screen.dart';

class MaterialAppStructure extends StatelessWidget {
  const MaterialAppStructure({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ListM',
      theme: MaterialThemeManager.getMaterialAppTheme(),
      home: const SplashScreen(),
      routes: {
        '/home': (context) => const MainScreen(),
      },
    );
  }
}
