import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:listm/core/app/cupertino_app_structure.dart';
import 'package:listm/core/app/material_app_structure.dart';

void main() {
  runApp(const TripWiseApp());
}

class TripWiseApp extends StatelessWidget {
  const TripWiseApp({super.key});

  @override
  Widget build(BuildContext context) =>
      Platform.isIOS ? const CupertinoApp() : const MaterialAppStructure();
}
