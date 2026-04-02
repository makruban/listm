import 'package:tripwise/core/usecases/usecase.dart';
import 'package:tripwise/domain/repositories/trip_item_relation_repository.dart';

class AddTripItemParams {
  final String tripId;
  final String itemId;

  AddTripItemParams({required this.tripId, required this.itemId});
}

class AddTripItemUseCase extends UseCase<void, AddTripItemParams> {
  final TripItemRelationRepository repository;

  AddTripItemUseCase(this.repository);

  @override
  Future<void> call(AddTripItemParams params) async {
    repository.addRelation(params.tripId, params.itemId);
  }
}
