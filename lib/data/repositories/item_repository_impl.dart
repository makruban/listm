import 'package:listm/core/error/exceptions/repository_exception.dart';
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
    try {
      final List<ItemModel> models = await localDataSource.getItemsFromCache();
      return models.map((m) => m.toEntity()).toList();
    } catch (e) {
      throw RepositoryLoadException('Failed to load items', e);
    }
  }

  @override
  Future<ItemEntity> getItemById(ItemId id) async {
    try {
      final ItemModel model = await localDataSource.getItemByIdFromCache(id);
      return model.toEntity();
    } catch (e) {
      throw RepositoryNotFoundException('Item not found with id: $id', e);
    }
  }

  @override
  Future<void> addItem(ItemEntity item) async {
    try {
      final ItemModel model = ItemModel.fromEntity(item);
      await localDataSource.addItemToCache(model);
    } catch (e) {
      throw RepositorySaveException('Failed to save item: $item', e);
    }
  }

  @override
  Future<void> updateItem(ItemEntity item) async {
    try {
      final ItemModel model = ItemModel.fromEntity(item);
      await localDataSource.updateItemInCache(model);
    } catch (e) {
      throw RepositoryUpdateException('Failed to update item: $item', e);
    }
  }

  @override
  Future<void> deleteItem(ItemId id) async {
    try {
      await localDataSource.deleteItemFromCache(id);
    } catch (e) {
      throw RepositoryDeleteException('Failed to delete item: $id', e);
    }
  }

  @override
  Future<void> deleteAllItems() async {
    try {
      await localDataSource.deleteAllItemsFromCache();
    } catch (e) {
      throw RepositoryDeleteException('Failed to delete all items', e);
    }
  }

  @override
  Stream<List<ItemEntity>> getItemsStream() {
    return localDataSource.getItemsStream().map((models) {
      return models.map((m) => m.toEntity()).toList();
    });
  }
}
