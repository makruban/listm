import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:listm/core/app/cupertino_app_structure.dart';
import 'package:listm/core/app/material_app_structure.dart';

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
