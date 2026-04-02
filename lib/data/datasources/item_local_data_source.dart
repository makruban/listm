import 'package:tripwise/core/resources/app_key_constants.dart';
import 'package:tripwise/data/models/item_model.dart';
import 'package:tripwise/domain/value_objects/item_id.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';

abstract class ItemLocalDataSource {
  Future<List<ItemModel>> getItemsFromCache();
  Future<ItemModel> getItemByIdFromCache(ItemId id);
  Future<void> addItemToCache(ItemModel item);
  Future<void> updateItemInCache(ItemModel item);
  Future<void> deleteItemFromCache(ItemId id);
  Future<void> clearCache();
  Future<void> deleteAllItemsFromCache();
  Future<bool> isCacheEmpty();
  Future<bool> isCacheNotEmpty();
  Stream<List<ItemModel>> getItemsStream();
}

class ItemLocalDataSourceImpl implements ItemLocalDataSource {
  static const String cacheKey = CacheKeys.items;

  final SharedPreferencesWithCache prefsWithCache;

  final _itemStreamController = StreamController<List<ItemModel>>.broadcast();

  ItemLocalDataSourceImpl({required this.prefsWithCache}) {
    // Initialize stream with current data
    getItemsFromCache().then((items) {
      _itemStreamController.add(items);
    });
  }

  static Future<ItemLocalDataSourceImpl> create() async {
    final prefsWithCache = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: <String>{cacheKey},
      ),
    );
    return ItemLocalDataSourceImpl(prefsWithCache: prefsWithCache);
  }

  @override
  Future<List<ItemModel>> getItemsFromCache() async {
    final jsonString = prefsWithCache.getString(cacheKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => ItemModel.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  @override
  Future<ItemModel> getItemByIdFromCache(ItemId id) async {
    final items = await getItemsFromCache();
    final item = items.firstWhere((item) => item.id == id.value,
        orElse: () => throw Exception('Item not found'));
    return item;
  }

  @override
  Future<void> addItemToCache(ItemModel item) async {
    final items = await getItemsFromCache();
    items.add(item);
    await _saveItemsToCache(items);
  }

  @override
  Future<void> updateItemInCache(ItemModel item) async {
    final items = await getItemsFromCache();
    final index = items.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      items[index] = item;
      await _saveItemsToCache(items);
    } else {
      throw Exception('Item not found');
    }
  }

  @override
  Future<void> deleteItemFromCache(ItemId id) async {
    final items = await getItemsFromCache();
    items.removeWhere((item) => item.id == id.value);
    await _saveItemsToCache(items);
  }

  Future<void> _saveItemsToCache(List<ItemModel> items) async {
    final jsonString = json.encode(items.map((item) => item.toJson()).toList());
    await prefsWithCache.setString(cacheKey, jsonString);
    _itemStreamController.add(items);
  }

  @override
  Stream<List<ItemModel>> getItemsStream() => _itemStreamController.stream;

  Future<void> clearCache() async {
    await prefsWithCache.clear();
  }

  /// Delete all items from cache
  Future<void> deleteAllItemsFromCache() async {
    await prefsWithCache.remove(cacheKey);
  }

  /// Check if the cache is empty
  Future<bool> isCacheEmpty() async {
    final jsonString = prefsWithCache.getString(cacheKey);
    return jsonString == null || jsonString.isEmpty;
  }

  /// Check if the cache is not empty
  Future<bool> isCacheNotEmpty() async {
    final jsonString = prefsWithCache.getString(cacheKey);
    return jsonString != null && jsonString.isNotEmpty;
  }
}
