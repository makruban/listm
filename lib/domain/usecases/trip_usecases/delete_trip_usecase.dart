import 'package:tripwise/core/usecases/usecase.dart';
import 'package:tripwise/domain/repositories/trip_repository.dart';
import 'package:tripwise/domain/value_objects/trip_id.dart';

/// Use case for deleting a trip from the repository.
class DeleteTripUseCase extends UseCase<void, TripId> {
  final TripRepository repository;

  DeleteTripUseCase(this.repository);

  @override
  Future<void> call(TripId id) async {
    await repository.deleteTrip(id);
  }
}
