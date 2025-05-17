import 'package:listm/core/usecases/usecase.dart';
import 'package:listm/domain/entities/trip_entity.dart';
import 'package:listm/domain/repositories/trip_repository.dart';

/// Use case for adding a trip to the repository.
class AddTripUseCase extends UseCase<void, TripEntity> {
  final TripRepository repository;

  AddTripUseCase(this.repository);

  @override
  Future<void> call(TripEntity trip) async {
    await repository.addTrip(trip);
  }
}
