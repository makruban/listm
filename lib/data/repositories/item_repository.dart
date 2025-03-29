import '../models/item.dart';

class ItemRepository {
  final List<Item> _items = [];

  Future<List<Item>> getItems() async {
    return _items;
  }

  Future<void> addItem(Item item) async {
    _items.add(item);
  }

  Future<void> removeItem(String id) async {
    _items.removeWhere((item) => item.id == id);
  }

  Future<void> updateItem(Item item) async {
    final index = _items.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      _items[index] = item;
    }
  }
}
