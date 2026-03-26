import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:listm/core/resources/app_routes.dart';
import 'package:listm/core/resources/asset_paths.dart';
import 'package:listm/presentation/bloc/app/app_bloc.dart';
import 'package:listm/presentation/bloc/app/app_state.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      listener: (context, state) {
        if (state is AppReady) {
          if (state.hasSeenOnboarding) {
            context.go(AppRoutes.home);
          } else {
            context.go(AppRoutes.onboarding);
          }
        }
      },
      child: const Scaffold(
        body: SplashBackground(),
      ),
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
            Color(0xFFB2DDF2),
            Color(0xFF6CAFD9),
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
