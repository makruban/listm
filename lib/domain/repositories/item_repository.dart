import 'package:tripwise/domain/entities/item_entity.dart';
import 'package:tripwise/domain/value_objects/item_id.dart';

abstract class ItemRepository {
  Future<List<ItemEntity>> getItems();
  Future<ItemEntity> getItemById(ItemId id);
  Future<void> addItem(ItemEntity item);
  Future<void> updateItem(ItemEntity item);
  Future<void> deleteItem(ItemId id);
  Future<void> deleteAllItems();
  Stream<List<ItemEntity>> getItemsStream();
}
