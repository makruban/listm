import 'package:listm/core/usecases/usecase.dart';
import 'package:listm/domain/entities/trip_detail_item.dart';
import 'package:listm/domain/repositories/item_repository.dart';
import 'package:listm/domain/repositories/trip_item_relation_repository.dart';
import 'package:listm/domain/value_objects/item_id.dart';

class GetItemsForTripUseCase extends UseCase<List<TripDetailItem>, String> {
  final TripItemRelationRepository relationRepository;
  final ItemRepository itemRepository;

  GetItemsForTripUseCase({
    required this.relationRepository,
    required this.itemRepository,
  });

  @override
  Future<List<TripDetailItem>> call(String tripId) async {
    final relations = relationRepository.getRelationsForTrip(tripId);
    final items = <TripDetailItem>[];
    for (final relation in relations) {
      try {
        final item = await itemRepository.getItemById(ItemId(relation.itemId));
        items.add(TripDetailItem(
          item: item,
          isCompleted: relation.isCompleted,
        ));
      } catch (_) {
        // Ignore items that don't exist anymore
      }
    }

    // Sort: Incomplete items first, then completed items
    items.sort((a, b) {
      if (a.isCompleted == b.isCompleted) return 0;
      return a.isCompleted ? 1 : -1;
    });

    return items;
  }
}
