/// All the SharedPreferences cache keys used in TripWise.
abstract class CacheKeys {
  /// Key under which we store the list of items.
  static const String items = 'CACHED_ITEMS';

  /// Key under which we store the list of trips.
  static const String trips = 'CACHED_TRIPS';

  /// Key under which we store the list of trip item relations.
  static const String tripItemRelations = 'CACHED_TRIP_ITEM_RELATIONS';

  /// Key under which we store the has seen onboarding flag.
  static const String hasSeenOnboarding = 'HAS_SEEN_ONBOARDING';
}
