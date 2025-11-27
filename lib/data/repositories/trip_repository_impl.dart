import 'package:listm/core/error/exceptions/repository_exception.dart';
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
    try {
      final List<TripModel> models = await localDataSource.getTripsFromCache();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw RepositoryLoadException('Failed to load trips', e);
    }
  }

  @override
  Future<TripEntity> getTripById(TripId id) async {
    try {
      final TripModel model = await localDataSource.getTripByIdFromCache(id);
      return model.toEntity();
    } catch (e) {
      throw RepositoryNotFoundException(
          'Trip not found with id: ${id.value}', e);
    }
  }

  @override
  Future<void> addTrip(TripEntity trip) async {
    try {
      final TripModel model = TripModel.fromEntity(trip);
      await localDataSource.addTripToCache(model);
    } catch (e) {
      throw RepositorySaveException('Failed to save trip: ${trip.title}', e);
    }
  }

  @override
  Future<void> updateTrip(TripEntity trip) async {
    try {
      final TripModel model = TripModel.fromEntity(trip);
      await localDataSource.updateTripInCache(model);
    } catch (e) {
      throw RepositoryUpdateException(
          'Failed to update trip: ${trip.title}', e);
    }
  }

  @override
  Future<void> deleteTrip(TripId id) async {
    try {
      await localDataSource.deleteTripFromCache(id);
    } catch (e) {
      throw RepositoryDeleteException('Failed to delete trip: ${id.value}', e);
    }
  }

  @override
  Future<void> deleteAllTrips() async {
    try {
      await localDataSource.deleteAllTripsFromCache();
    } catch (e) {
      throw RepositoryDeleteException('Failed to delete all trips', e);
    }
  }
}
