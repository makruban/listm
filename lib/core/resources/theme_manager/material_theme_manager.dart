import 'package:flutter/material.dart';

class MaterialThemeManager {
  static ThemeData getMaterialAppTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      brightness: Brightness.light,
    );
  }
}
