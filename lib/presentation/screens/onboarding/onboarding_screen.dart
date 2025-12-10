import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:listm/presentation/screens/onboarding/cupertino_onboarding_screen.dart';
import 'package:listm/presentation/screens/onboarding/material_onboarding_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? const CupertinoOnboardingScreen()
        : const MaterialOnboardingScreen();
  }
}
