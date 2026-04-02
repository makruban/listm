import 'package:flutter/cupertino.dart';

class CupertinoThemeManager {
  static CupertinoThemeData getCupertinoAppTheme() {
    return const CupertinoThemeData(
      brightness: Brightness.light,
      primaryColor: CupertinoColors.systemBlue,
      scaffoldBackgroundColor: CupertinoColors.systemBackground,
      barBackgroundColor: CupertinoColors.systemBackground,
    );
  }
}
