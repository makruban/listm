import 'dart:convert';
import 'package:listm/core/resources/app_key_constants.dart';
import 'package:listm/domain/entities/trip_item_relation_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class TripItemRelationLocalDataSource {
  List<TripItemRelationEntity> getRelations();
  Future<void> addRelation(TripItemRelationEntity relation);
  Future<void> removeRelation(TripItemRelationEntity relation);
}

class TripItemRelationLocalDataSourceImpl
    implements TripItemRelationLocalDataSource {
  static const String cacheKey = CacheKeys.tripItemRelations;
  final SharedPreferencesWithCache prefsWithCache;

  TripItemRelationLocalDataSourceImpl({required this.prefsWithCache});

  @override
  List<TripItemRelationEntity> getRelations() {
    final jsonString = prefsWithCache.getString(cacheKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList
          .map((json) => TripItemRelationEntity(
                tripId: json['tripId'] as String,
                itemId: json['itemId'] as String,
              ))
          .toList();
    } else {
      return [];
    }
  }

  @override
  Future<void> addRelation(TripItemRelationEntity relation) async {
    final relations = getRelations();
    // Simple check to avoid duplicates in list
    if (!relations.any(
        (r) => r.tripId == relation.tripId && r.itemId == relation.itemId)) {
      relations.add(relation);
      await _saveRelationsToCache(relations);
    }
  }

  @override
  Future<void> removeRelation(TripItemRelationEntity relation) async {
    final relations = getRelations();
    relations.removeWhere(
      (r) => r.tripId == relation.tripId && r.itemId == relation.itemId,
    );
    await _saveRelationsToCache(relations);
  }

  Future<void> _saveRelationsToCache(
      List<TripItemRelationEntity> relations) async {
    final jsonList = relations
        .map((r) => {
              'tripId': r.tripId,
              'itemId': r.itemId,
            })
        .toList();
    await prefsWithCache.setString(cacheKey, json.encode(jsonList));
  }
}
