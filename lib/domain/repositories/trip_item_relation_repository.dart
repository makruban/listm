abstract class TripItemRelationRepository {
  List<String> getItemsForTrip(String tripId);
  List<String> getTripsForItem(String itemId);
  void addRelation(String tripId, String itemId);
  void removeRelation(String tripId, String itemId);
}
