import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:listm/core/resources/theme_manager/cupertino_theme_manager.dart';
import 'package:listm/core/resources/theme_manager/material_theme_manager.dart';
import 'package:listm/presentation/screens/main_screen.dart';
import 'package:listm/presentation/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? const CupertinoAppStructure()
        : const MaterialAppStructure();
  }
}

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
