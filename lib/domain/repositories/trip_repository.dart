import 'package:listm/domain/entities/trip_entity.dart';
import 'package:listm/domain/value_objects/trip_id.dart';

abstract class TripRepository {
  Future<List<TripEntity>> getTrips();
  Future<TripEntity> getTripById(TripId id);
  Future<void> addTrip(TripEntity trip);
  Future<void> updateTrip(TripEntity trip);
  Future<void> deleteTrip(TripId id);
  Future<void> deleteAllTrips();
  Stream<List<TripEntity>> getTripsStream();
}
