import 'package:listm/core/usecases/usecase.dart';
import 'package:listm/domain/entities/trip_entity.dart';
import 'package:listm/domain/repositories/trip_repository.dart';
import 'package:listm/domain/value_objects/no_params.dart';

class GetTripsStreamUseCase extends StreamUseCase<List<TripEntity>, NoParams> {
  final TripRepository repository;

  GetTripsStreamUseCase(this.repository);

  @override
  Stream<List<TripEntity>> call(NoParams params) {
    return repository.getTripsStream();
  }
}
