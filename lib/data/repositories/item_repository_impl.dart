import 'package:listm/data/datasources/item_local_data_source.dart';
import 'package:listm/data/models/item_model.dart';
import 'package:listm/domain/entities/item_entity.dart';
import 'package:listm/domain/repositories/item_repository.dart';
import 'package:listm/domain/value_objects/item_id.dart';

/// Concrete implementation of [ItemRepository], mapping between
/// [ItemModel] (data layer) and [ItemEntity] (domain layer).
class ItemRepositoryImpl implements ItemRepository {
  final ItemLocalDataSource localDataSource;

  ItemRepositoryImpl({required this.localDataSource});

  @override
  Future<List<ItemEntity>> getItems() async {
    // Fetch models from the data source and convert to domain entities
    final List<ItemModel> models = await localDataSource.getItemsFromCache();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<ItemEntity> getItemById(ItemId id) async {
    // Lookup in data source by ItemId
    final ItemModel model = await localDataSource.getItemByIdFromCache(id);
    return model.toEntity();
  }

  @override
  Future<void> addItem(ItemEntity item) async {
    // Convert domain entity to data model
    final ItemModel model = ItemModel.fromEntity(item);
    await localDataSource.addItemToCache(model);
  }

  @override
  Future<void> updateItem(ItemEntity item) async {
    final ItemModel model = ItemModel.fromEntity(item);
    await localDataSource.updateItemInCache(model);
  }

  @override
  Future<void> deleteItem(ItemId id) async {
    // Delete by ItemId
    await localDataSource.deleteItemFromCache(id);
  }

  @override
  Future<void> deleteAllItems() async {
    // Remove all items from cache
    await localDataSource.deleteAllItemsFromCache();
  }
}
