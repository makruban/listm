import 'package:listm/core/usecases/usecase.dart';
import 'package:listm/domain/entities/trip_entity.dart';
import 'package:listm/domain/repositories/trip_repository.dart';

/// Use case for updating a trip in the repository.
class UpdateTripUseCase extends UseCase<void, TripEntity> {
  final TripRepository repository;

  UpdateTripUseCase(this.repository);

  @override
  Future<void> call(TripEntity trip) async {
    await repository.updateTrip(trip);
  }
}
