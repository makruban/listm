import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:listm/core/app/cupertino_app_structure.dart';
import 'package:listm/core/app/material_app_structure.dart';
import 'package:listm/core/di/app_bloc_providers.dart';
import 'package:listm/core/di/injection.dart';
import 'package:listm/core/util/unique_id_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
// Initialize the dependency injection
  await configureDependencies();
  await UniqueIdService.instance.initialize();
  runApp(AppBlocProviders(child: const TripWiseApp()));
}

class TripWiseApp extends StatelessWidget {
  const TripWiseApp({super.key});

  @override
  Widget build(BuildContext context) => Platform.isIOS
      ? const CupertinoAppStructure()
      : const MaterialAppStructure();
}
