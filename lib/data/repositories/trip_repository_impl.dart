import 'package:listm/data/datasources/trip_local_data_source.dart';
import 'package:listm/data/models/trip_model.dart';
import 'package:listm/domain/entities/trip_entity.dart';
import 'package:listm/domain/repositories/trip_repository.dart';
import 'package:listm/domain/value_objects/trip_id.dart';

// Concrete implementation of [TripRepository], mapping between
/// [TripModel] (data layer) and [TripEntity] (domain layer).
class TripRepositoryImpl implements TripRepository {
  final TripLocalDataSource localDataSource;

  TripRepositoryImpl({required this.localDataSource});

  @override
  Future<List<TripEntity>> getTrips() async {
    // Fetch models from the data source and convert to domain entities
    final List<TripModel> models = await localDataSource.getTripsFromCache();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<TripEntity> getTripById(TripId id) async {
    // Wrap string id into TripId for data source lookup
    final TripModel model = await localDataSource.getTripByIdFromCache(id);
    return model.toEntity();
  }

  @override
  Future<void> addTrip(TripEntity trip) async {
    // Convert domain entity to data model before saving
    final TripModel model = TripModel.fromEntity(trip);
    await localDataSource.addTripToCache(model);
  }

  @override
  Future<void> updateTrip(TripEntity trip) async {
    final TripModel model = TripModel.fromEntity(trip);
    await localDataSource.updateTripInCache(model);
  }

  @override
  Future<void> deleteTrip(TripId id) async {
    await localDataSource.deleteTripFromCache(id);
  }

  @override
  Future<void> deleteAllTrips() async {
    await localDataSource.deleteAllTripsFromCache();
  }
}
