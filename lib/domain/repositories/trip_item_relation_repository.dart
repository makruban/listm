import 'package:tripwise/domain/entities/trip_item_relation_entity.dart';

abstract class TripItemRelationRepository {
  List<String> getItemsForTrip(String tripId);
  List<TripItemRelationEntity> getRelationsForTrip(String tripId);
  List<String> getTripsForItem(String itemId);
  void addRelation(String tripId, String itemId);
  void updateRelation(TripItemRelationEntity relation);
  void removeRelation(String tripId, String itemId);
}
