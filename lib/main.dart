import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:listm/core/app/cupertino_app_structure.dart';
import 'package:listm/core/app/material_app_structure.dart';
import 'package:listm/l10n/app_localizations.dart';

void main() {
  runApp(const TripWiseApp());
}

class TripWiseApp extends StatelessWidget {
  const TripWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Pick the correct “root” App widget based on platform
    if (Platform.isIOS) {
      return CupertinoApp(
        // Wire up localization
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        // Your iOS‐style home screen
        home: const CupertinoAppStructure(),
      );
    } else {
      return MaterialApp(
        // Wire up localization
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        // Use Material 3 if you like
        theme: ThemeData(useMaterial3: true),
        // Your Android/desktop home screen
        home: const MaterialAppStructure(),
      );
    }
  }
}
