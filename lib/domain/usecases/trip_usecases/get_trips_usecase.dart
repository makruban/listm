import 'package:tripwise/core/usecases/usecase.dart';
import 'package:tripwise/domain/entities/trip_entity.dart';
import 'package:tripwise/domain/repositories/trip_repository.dart';
import 'package:tripwise/domain/value_objects/no_params.dart';

/// Use case for retrieving all trips from the repository.
class GetTripsUseCase extends UseCase<List<TripEntity>, NoParams> {
  final TripRepository repository;

  GetTripsUseCase(this.repository);

  @override
  Future<List<TripEntity>> call(NoParams params) async {
    return await repository.getTrips();
  }
}
