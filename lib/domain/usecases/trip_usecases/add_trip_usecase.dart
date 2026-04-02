import 'package:tripwise/core/usecases/usecase.dart';
import 'package:tripwise/domain/entities/trip_entity.dart';
import 'package:tripwise/domain/repositories/trip_repository.dart';

/// Use case for adding a trip to the repository.
class AddTripUseCase extends UseCase<void, TripEntity> {
  final TripRepository repository;

  AddTripUseCase(this.repository);

  @override
  Future<void> call(TripEntity trip) async {
    await repository.addTrip(trip);
  }
}
