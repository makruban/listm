import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tripwise/core/app/material_app_structure.dart';
import 'package:tripwise/core/di/app_bloc_providers.dart';
import 'package:tripwise/core/di/injection.dart';
import 'package:tripwise/core/util/unique_id_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize the dependency injection
  await configureDependencies();
  await UniqueIdService.instance.initialize();

  runApp(
    const AppBlocProviders(child: TripWiseApp()),
  );
}

class TripWiseApp extends StatelessWidget {
  const TripWiseApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialAppStructure();
}
