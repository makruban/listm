import 'package:listm/data/datasources/trip_item_relation_local_data_source.dart';
import 'package:listm/domain/entities/trip_item_relation_entity.dart';
import 'package:listm/domain/repositories/trip_item_relation_repository.dart';

class TripItemRelationRepositoryImpl implements TripItemRelationRepository {
  final TripItemRelationLocalDataSource localDataSource;

  TripItemRelationRepositoryImpl({required this.localDataSource});

  @override
  List<String> getItemsForTrip(String tripId) {
    return localDataSource
        .getRelations()
        .where((r) => r.tripId == tripId)
        .map((r) => r.itemId)
        .toList();
  }

  @override
  List<String> getTripsForItem(String itemId) {
    return localDataSource
        .getRelations()
        .where((r) => r.itemId == itemId)
        .map((r) => r.tripId)
        .toList();
  }

  @override
  void addRelation(String tripId, String itemId) {
    // Fire and forget for async persistence to maintain sync interface
    localDataSource
        .addRelation(TripItemRelationEntity(tripId: tripId, itemId: itemId));
  }

  @override
  void removeRelation(String tripId, String itemId) {
    // Fire and forget for async persistence to maintain sync interface
    localDataSource
        .removeRelation(TripItemRelationEntity(tripId: tripId, itemId: itemId));
  }
}
