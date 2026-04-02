import 'package:tripwise/core/usecases/usecase.dart';
import 'package:tripwise/domain/repositories/trip_item_relation_repository.dart';

class RemoveTripItemParams {
  final String tripId;
  final String itemId;

  RemoveTripItemParams({required this.tripId, required this.itemId});
}

class RemoveTripItemUseCase extends UseCase<void, RemoveTripItemParams> {
  final TripItemRelationRepository repository;

  RemoveTripItemUseCase(this.repository);

  @override
  Future<void> call(RemoveTripItemParams params) async {
    repository.removeRelation(params.tripId, params.itemId);
  }
}
