import 'package:tripwise/core/usecases/usecase.dart';
import 'package:tripwise/domain/entities/trip_entity.dart';
import 'package:tripwise/domain/repositories/trip_repository.dart';
import 'package:tripwise/domain/value_objects/trip_id.dart';

/// Use case for retrieving a trip by its ID from the repository.
class GetTripByIdUseCase extends UseCase<TripEntity, TripId> {
  final TripRepository repository;

  GetTripByIdUseCase(this.repository);

  @override
  Future<TripEntity> call(TripId id) async {
    return await repository.getTripById(id);
  }
}
