import 'package:flutter/material.dart';
import 'dart:async';
import 'package:go_router/go_router.dart';
import 'package:listm/core/resources/app_routes.dart';
import 'package:listm/core/resources/asset_paths.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 2),
      () => GoRouter.of(context).go(AppRoutes.onboarding),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SplashBackground(),
    );
  }
}

class SplashBackground extends StatelessWidget {
  const SplashBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Color(0xFFB2DDF2), // light blue at bottom
            Color(0xFF6CAFD9), // deeper blue at top
          ],
        ),
      ),
      child: Center(
        child: Image.asset(
          AssetPaths.splashImage,
          scale: 6.0,
        ),
      ),
    );
  }
}
