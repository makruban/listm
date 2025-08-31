import 'package:listm/core/usecases/usecase.dart';
import 'package:listm/domain/repositories/trip_repository.dart';
import 'package:listm/domain/value_objects/no_params.dart';

/// Use case for deleting all trips from the repository.
class DeleteAllTripsUseCase extends UseCase<void, NoParams> {
  final TripRepository repository;

  DeleteAllTripsUseCase(this.repository);

  @override
  Future<void> call(NoParams params) async {
    await repository.deleteAllTrips();
  }
}
