import 'dart:convert';
import 'dart:async';

import 'package:listm/core/resources/app_key_constants.dart';
import 'package:listm/data/models/item_model.dart';
import 'package:listm/data/models/trip_model.dart';
import 'package:listm/domain/value_objects/item_id.dart';
import 'package:listm/domain/value_objects/trip_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class TripLocalDataSource {
  Future<List<TripModel>> getTripsFromCache();
  Future<TripModel> getTripByIdFromCache(TripId id);
  Future<void> addTripToCache(TripModel trip);
  Future<void> updateTripInCache(TripModel trip);
  Future<void> deleteTripFromCache(TripId id);
  Future<void> clearCache();
  Future<void> deleteAllTripsFromCache();
  Future<bool> isCacheEmpty();
  Future<bool> isCacheNotEmpty();
  Future<bool> tripsExistInCache();
  Stream<List<TripModel>> getTripsStream();
}

class TripLocalDataSourceImpl implements TripLocalDataSource {
  static const String cacheKey = CacheKeys.trips;

  final SharedPreferencesWithCache prefsWithCache;
  final _tripsStreamController = StreamController<List<TripModel>>.broadcast();

  TripLocalDataSourceImpl({required this.prefsWithCache}) {}

  static Future<TripLocalDataSourceImpl> create() async {
    final prefsWithCache = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: <String>{cacheKey},
      ),
    );
    return TripLocalDataSourceImpl(prefsWithCache: prefsWithCache);
  }

  @override
  Future<List<TripModel>> getTripsFromCache() async {
    final jsonString = prefsWithCache.getString(cacheKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => TripModel.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  @override
  Future<TripModel> getTripByIdFromCache(TripId id) async {
    final trips = await getTripsFromCache();
    final trip = trips.firstWhere((trip) => trip.id == id.value,
        orElse: () => throw Exception('Trip not found'));
    return trip;
  }

  @override
  Future<void> addTripToCache(TripModel trip) async {
    final trips = await getTripsFromCache();
    trips.add(trip);
    await _saveTripsToCache(trips);
  }

  @override
  Future<void> updateTripInCache(TripModel trip) async {
    final trips = await getTripsFromCache();
    final index = trips.indexWhere((i) => i.id == trip.id);
    if (index != -1) {
      trips[index] = trip;
      await _saveTripsToCache(trips);
    }
  }

  @override
  Future<void> deleteTripFromCache(TripId id) async {
    final trips = await getTripsFromCache();
    trips.removeWhere((trip) => trip.id == id.value);
    await _saveTripsToCache(trips);
  }

  Future<void> _saveTripsToCache(List<TripModel> trips) async {
    final jsonString = json.encode(trips.map((trip) => trip.toJson()).toList());
    await prefsWithCache.setString(cacheKey, jsonString);
    _tripsStreamController.add(trips);
  }

  @override
  Stream<List<TripModel>> getTripsStream() {
    return _tripsStreamController.stream;
  }

  /// Delete all trips from cache
  Future<void> deleteAllTripsFromCache() async {
    await prefsWithCache.remove(cacheKey);
    _tripsStreamController.add([]);
  }

  /// Check if trips exist in cache
  Future<bool> tripsExistInCache() async {
    final jsonString = prefsWithCache.getString(cacheKey);
    return jsonString != null && jsonString.isNotEmpty;
  }

  /// Check if the cache is empty
  Future<bool> isCacheEmpty() async {
    final jsonString = prefsWithCache.getString(cacheKey);
    return jsonString == null || jsonString.isEmpty;
  }

  /// Clear the cache
  Future<void> clearCache() async {
    await prefsWithCache.clear();
    _tripsStreamController.add([]);
  }

  /// Check if the cache is not empty
  Future<bool> isCacheNotEmpty() async {
    final jsonString = prefsWithCache.getString(cacheKey);
    return jsonString != null && jsonString.isNotEmpty;
  }
}
