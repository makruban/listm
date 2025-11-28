/// Application-wide route names.
/// Used by GoRouter and for navigation throughout TripWise.
abstract class AppRoutes {
  /// Initial splash screen route.
  static const String splash = '/';

  /// Main home screen route.
  static const String home = '/home';

  // TODO: Add more route names as needed:
  // static const String packingLists = '/packingLists';
  // static const String specificList = '/packingLists/:id';
  static const String tripDetail = 'trip/:id';
}
