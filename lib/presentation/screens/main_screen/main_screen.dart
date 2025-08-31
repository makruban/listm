import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:listm/presentation/screens/main_screen/cupertino_main_screen.dart';
import 'package:listm/presentation/screens/main_screen/material_main_screen.dart';

/// Top-level entrypoint: picks the right scaffold for each platform.
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? const CupertinoMainScreen()
        : const MaterialMainScreen();
  }
}
