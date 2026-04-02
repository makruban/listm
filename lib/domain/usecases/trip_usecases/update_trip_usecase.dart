import 'package:tripwise/core/usecases/usecase.dart';
import 'package:tripwise/domain/entities/trip_entity.dart';
import 'package:tripwise/domain/repositories/trip_repository.dart';

/// Use case for updating a trip in the repository.
class UpdateTripUseCase extends UseCase<void, TripEntity> {
  final TripRepository repository;

  UpdateTripUseCase(this.repository);

  @override
  Future<void> call(TripEntity trip) async {
    await repository.updateTrip(trip);
  }
}
