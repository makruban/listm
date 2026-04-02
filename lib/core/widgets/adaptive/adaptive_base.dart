import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// A generic builder that handles the check
abstract class AdaptiveWidget extends StatelessWidget {
  const AdaptiveWidget({super.key});

  Widget buildCupertino(BuildContext context);
  Widget buildMaterial(BuildContext context);

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;
    if (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS) {
      return buildCupertino(context);
    }
    return buildMaterial(context);
  }
}
