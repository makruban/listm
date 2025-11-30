import 'package:listm/domain/entities/trip_item_relation_entity.dart';
import 'package:listm/domain/repositories/trip_item_relation_repository.dart';

class TripItemRelationRepositoryImpl implements TripItemRelationRepository {
  // In-memory storage as requested
  final List<TripItemRelationEntity> relations = [];

  @override
  List<String> getItemsForTrip(String tripId) =>
      relations.where((r) => r.tripId == tripId).map((r) => r.itemId).toList();

  @override
  List<String> getTripsForItem(String itemId) =>
      relations.where((r) => r.itemId == itemId).map((r) => r.tripId).toList();

  @override
  void addRelation(String tripId, String itemId) {
    // Prevent duplicates if needed, but for now following simple add logic
    if (!relations.any((r) => r.tripId == tripId && r.itemId == itemId)) {
      relations.add(TripItemRelationEntity(tripId: tripId, itemId: itemId));
    }
  }

  @override
  void removeRelation(String tripId, String itemId) {
    relations.removeWhere((r) => r.tripId == tripId && r.itemId == itemId);
  }
}
