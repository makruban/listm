import 'package:listm/core/usecases/usecase.dart';
import 'package:listm/domain/entities/item_entity.dart';
import 'package:listm/domain/repositories/item_repository.dart';
import 'package:listm/domain/repositories/trip_item_relation_repository.dart';
import 'package:listm/domain/value_objects/item_id.dart';

class GetItemsForTripUseCase extends UseCase<List<ItemEntity>, String> {
  final TripItemRelationRepository relationRepository;
  final ItemRepository itemRepository;

  GetItemsForTripUseCase({
    required this.relationRepository,
    required this.itemRepository,
  });

  @override
  Future<List<ItemEntity>> call(String tripId) async {
    final itemIds = relationRepository.getItemsForTrip(tripId);
    final items = <ItemEntity>[];
    for (final id in itemIds) {
      try {
        final item = await itemRepository.getItemById(ItemId(id));
        items.add(item);
      } catch (_) {
        // Ignore items that don't exist anymore
      }
    }
    return items;
  }
}
