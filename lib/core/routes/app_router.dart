import 'package:go_router/go_router.dart';
import 'package:listm/core/resources/app_routes.dart';
import 'package:listm/presentation/screens/main_screen/material_main_screen.dart';
import 'package:listm/presentation/screens/onboarding/material_onboarding_screen.dart';
import 'package:listm/presentation/screens/splash_screen.dart';
import 'package:listm/presentation/screens/trip_detail_screen/material_trip_detail_screen.dart';
import 'package:listm/presentation/screens/settings_screen/material_app_settings_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
      routes: [
        // add more nested routes here...
      ],
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      name: 'onboarding',
      builder: (context, state) => const MaterialOnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const MaterialMainScreen(),
      routes: [
        GoRoute(
          path: AppRoutes.tripDetail,
          name: 'tripDetail',
          builder: (context, state) {
            final tripId = state.pathParameters['id']!;
            return MaterialTripDetailScreen(tripId: tripId);
          },
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.settings,
      name: 'settings',
      builder: (context, state) => const MaterialAppSettingsScreen(),
    ),
  ],
);
