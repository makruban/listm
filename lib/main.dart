import 'package:device_preview/device_preview.dart';
import 'package:device_preview_screenshot/device_preview_screenshot.dart';
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
    DevicePreview(
      enabled: !kReleaseMode,
      tools: [
        ...DevicePreview.defaultTools,
        DevicePreviewScreenshot(),
      ],
      builder: (context) => AppBlocProviders(child: const TripWiseApp()),
    ),
  );
}

class TripWiseApp extends StatelessWidget {
  const TripWiseApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialAppStructure();
}
