import 'package:listm/domain/entities/item_entity.dart';

class ItemRepository {
  final List<ItemEntity> _items = [];

  Future<List<ItemEntity>> getItems() async {
    return _items;
  }

  Future<void> addItem(ItemEntity item) async {
    _items.add(item);
  }

  Future<void> removeItem(String id) async {
    _items.removeWhere((item) => item.id == id);
  }

  Future<void> updateItem(ItemEntity item) async {
    final index = _items.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      _items[index] = item;
    }
  }
}
