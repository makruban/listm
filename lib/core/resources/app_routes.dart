/// Application-wide route names.
/// Used by GoRouter and for navigation throughout TripWise.
abstract class AppRoutes {
  /// Initial splash screen route.
  static const String splash = '/';

  /// Onboarding screen route.
  static const String onboarding = '/onboarding';

  /// Main home screen route.
  static const String home = '/home';

  // TODO: Add more route names as needed:
  static const String tripDetail = 'trip/:id';

  /// Settings Screen.
  static const String settings = '/settings';
}
