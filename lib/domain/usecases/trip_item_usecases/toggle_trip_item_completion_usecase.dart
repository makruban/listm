import 'package:tripwise/core/usecases/usecase.dart';
import 'package:tripwise/domain/entities/trip_item_relation_entity.dart';
import 'package:tripwise/domain/repositories/trip_item_relation_repository.dart';

class ToggleTripItemCompletionUseCase
    extends UseCase<void, ToggleTripItemCompletionParams> {
  final TripItemRelationRepository repository;

  ToggleTripItemCompletionUseCase(this.repository);

  @override
  Future<void> call(ToggleTripItemCompletionParams params) async {
    final relations = repository.getRelationsForTrip(params.tripId);

    // Find the relation for this item
    final relation = relations.firstWhere(
      (r) => r.itemId == params.itemId,
      orElse: () => throw Exception('Relation not found'),
    );

    // Toggle completion status
    final updatedRelation = TripItemRelationEntity(
      tripId: relation.tripId,
      itemId: relation.itemId,
      isCompleted: !relation.isCompleted,
    );

    repository.updateRelation(updatedRelation);
  }
}

class ToggleTripItemCompletionParams {
  final String tripId;
  final String itemId;

  ToggleTripItemCompletionParams({
    required this.tripId,
    required this.itemId,
  });
}
