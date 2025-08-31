import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

/// Enhanced service for generating and managing unique identifiers
/// Optimized for SharedPreferencesWithCache with advanced caching strategies
class UniqueIdService {
  static const String _usedIdsKey = 'used_entity_ids';
  static const String _tripIdsKey = 'used_trip_ids';
  static const String _itemIdsKey = 'used_item_ids';
  static const String _categoryIdsKey = 'used_category_ids';
  static const String _countersKey = 'id_counters';
  static const String _lastCleanupKey = 'last_cleanup_timestamp';

  static UniqueIdService? _instance;
  static SharedPreferencesWithCache? _prefs;

  // In-memory caches - now redundant with SharedPreferencesWithCache but kept for additional performance
  Set<String> _cachedUsedIds = {};
  Set<String> _cachedTripIds = {};
  Set<String> _cachedItemIds = {};
  Set<String> _cachedCategoryIds = {};

  // Counters for sequential ID generation (alternative strategy)
  Map<String, int> _counters = {};

  bool _isInitialized = false;
  DateTime? _lastCleanup;

  UniqueIdService._internal();

  /// Singleton instance
  static UniqueIdService get instance {
    _instance ??= UniqueIdService._internal();
    return _instance!;
  }

  /// Initialize with enhanced caching options
  Future<void> initialize({
    Duration? maxCacheTime,
    bool enablePeriodicCleanup = true,
  }) async {
    if (_isInitialized) return;

    _prefs ??= await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(
        // Cache our frequently accessed keys
        allowList: <String>{
          _usedIdsKey,
          _tripIdsKey,
          _itemIdsKey,
          _categoryIdsKey,
          _countersKey,
          _lastCleanupKey,
        },
      ),
    );

    await _loadAllData();

    if (enablePeriodicCleanup) {
      _schedulePeriodicCleanup();
    }

    _isInitialized = true;
  }

  /// Load all data including counters and cleanup info
  Future<void> _loadAllData() async {
    // Load ID sets (very fast with SharedPreferencesWithCache)
    final List<String> usedIds = _prefs!.getStringList(_usedIdsKey) ?? [];
    final List<String> tripIds = _prefs!.getStringList(_tripIdsKey) ?? [];
    final List<String> itemIds = _prefs!.getStringList(_itemIdsKey) ?? [];
    final List<String> categoryIds =
        _prefs!.getStringList(_categoryIdsKey) ?? [];

    _cachedUsedIds = usedIds.toSet();
    _cachedTripIds = tripIds.toSet();
    _cachedItemIds = itemIds.toSet();
    _cachedCategoryIds = categoryIds.toSet();

    // Load counters for sequential ID generation
    final List<String>? countersList = _prefs!.getStringList(_countersKey);
    if (countersList != null) {
      _counters = Map.fromEntries(
        countersList.map((e) {
          final parts = e.split(':');
          return MapEntry(parts[0], int.parse(parts[1]));
        }),
      );
    }

    // Load last cleanup timestamp
    final int? lastCleanupMs = _prefs!.getInt(_lastCleanupKey);
    if (lastCleanupMs != null) {
      _lastCleanup = DateTime.fromMillisecondsSinceEpoch(lastCleanupMs);
    }
  }

  /// Generate unique ID with multiple strategies
  Future<String> generateUniqueId({
    String prefix = '',
    IdGenerationStrategy strategy = IdGenerationStrategy.timestampRandom,
  }) async {
    _ensureInitialized();

    String newId;

    switch (strategy) {
      case IdGenerationStrategy.timestampRandom:
        newId = await _generateTimestampRandomId(prefix);
        break;
      case IdGenerationStrategy.sequential:
        newId = await _generateSequentialId(prefix);
        break;
      case IdGenerationStrategy.uuid:
        newId = await _generateUuidLikeId(prefix);
        break;
    }

    // Register the ID
    _cachedUsedIds.add(newId);
    await _persistUsedIds();

    return newId;
  }

  /// Generate Trip ID with optimized caching
  Future<String> generateTripId({
    IdGenerationStrategy strategy = IdGenerationStrategy.timestampRandom,
  }) async {
    _ensureInitialized();

    String tripId = await generateUniqueId(
      prefix: 'trip_',
      strategy: strategy,
    );

    // Add to trip-specific cache
    _cachedTripIds.add(tripId);
    await _persistTripIds();

    return tripId;
  }

  /// Generate Item ID with optimized caching
  Future<String> generateItemId({
    IdGenerationStrategy strategy = IdGenerationStrategy.timestampRandom,
  }) async {
    _ensureInitialized();

    String itemId = await generateUniqueId(
      prefix: 'item_',
      strategy: strategy,
    );

    // Add to item-specific cache
    _cachedItemIds.add(itemId);
    await _persistItemIds();

    return itemId;
  }

  /// Generate Category ID
  Future<String> generateCategoryId({
    IdGenerationStrategy strategy = IdGenerationStrategy.timestampRandom,
  }) async {
    _ensureInitialized();

    String categoryId = await generateUniqueId(
      prefix: 'cat_',
      strategy: strategy,
    );

    _cachedCategoryIds.add(categoryId);
    await _persistCategoryIds();

    return categoryId;
  }

  /// Batch generate IDs for better performance
  Future<List<String>> generateBatchIds({
    required int count,
    String prefix = '',
    EntityType? type,
    IdGenerationStrategy strategy = IdGenerationStrategy.timestampRandom,
  }) async {
    _ensureInitialized();

    final List<String> ids = [];
    final Set<String> newIds = {};

    for (int i = 0; i < count; i++) {
      String id;
      do {
        switch (strategy) {
          case IdGenerationStrategy.timestampRandom:
            id = _generateTimestampRandomIdSync(prefix, i);
            break;
          case IdGenerationStrategy.sequential:
            id = await _generateSequentialId(prefix);
            break;
          case IdGenerationStrategy.uuid:
            id = _generateUuidLikeIdSync(prefix);
            break;
        }
      } while (_cachedUsedIds.contains(id) || newIds.contains(id));

      ids.add(id);
      newIds.add(id);
    }

    // Batch update caches
    _cachedUsedIds.addAll(newIds);

    if (type != null) {
      switch (type) {
        case EntityType.trip:
          _cachedTripIds.addAll(newIds);
          break;
        case EntityType.item:
          _cachedItemIds.addAll(newIds);
          break;
        case EntityType.category:
          _cachedCategoryIds.addAll(newIds);
          break;
      }
    }

    // Batch persist - SharedPreferencesWithCache makes this efficient
    await _batchPersist(type);

    return ids;
  }

  /// Check if ID exists (very fast with cache)
  bool isIdUsed(String id) {
    _ensureInitialized();
    return _cachedUsedIds.contains(id);
  }

  /// Get detailed statistics
  Map<String, dynamic> getDetailedStatistics() {
    _ensureInitialized();

    return {
      'totalIds': _cachedUsedIds.length,
      'tripIds': _cachedTripIds.length,
      'itemIds': _cachedItemIds.length,
      'categoryIds': _cachedCategoryIds.length,
      'counters': Map.from(_counters),
      'lastCleanup': _lastCleanup?.toIso8601String(),
      'cacheStatus': 'SharedPreferencesWithCache enabled',
      'memoryUsage': {
        'usedIds': _cachedUsedIds.length,
        'tripIds': _cachedTripIds.length,
        'itemIds': _cachedItemIds.length,
        'categoryIds': _cachedCategoryIds.length,
      }
    };
  }

  /// Cleanup old or unused IDs (optional maintenance)
  Future<void> performCleanup({Duration? olderThan}) async {
    _ensureInitialized();

    olderThan ??=
        const Duration(days: 365); // Default: cleanup IDs older than 1 year
    final cutoffTime = DateTime.now().subtract(olderThan);

    // This is a simplified cleanup - in a real app you'd need to track creation times
    // For now, just update the last cleanup time
    _lastCleanup = DateTime.now();
    await _prefs!.setInt(_lastCleanupKey, _lastCleanup!.millisecondsSinceEpoch);
  }

  /// Force cache refresh (usually not needed)
  Future<void> refreshCache() async {
    _ensureInitialized();
    await _loadAllData();
  }

  // Private helper methods

  void _ensureInitialized() {
    if (!_isInitialized) {
      throw StateError(
          'EnhancedUniqueIdService must be initialized before use. Call initialize() first.');
    }
  }

  Future<String> _generateTimestampRandomId(String prefix) async {
    String id;
    int attempts = 0;
    do {
      id = _generateTimestampRandomIdSync(prefix, attempts);
      attempts++;
    } while (_cachedUsedIds.contains(id) && attempts < 100);

    return id;
  }

  String _generateTimestampRandomIdSync(String prefix, int offset) {
    final random = Random();
    final timestamp = DateTime.now().millisecondsSinceEpoch + offset;
    final randomPart = random.nextInt(999999).toString().padLeft(6, '0');
    return '$prefix${timestamp}_$randomPart';
  }

  Future<String> _generateSequentialId(String prefix) async {
    final key = '${prefix}counter';
    final currentCount = _counters[key] ?? 0;
    final newCount = currentCount + 1;

    _counters[key] = newCount;
    await _persistCounters();

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '$prefix${timestamp}_${newCount.toString().padLeft(6, '0')}';
  }

  Future<String> _generateUuidLikeId(String prefix) async {
    return _generateUuidLikeIdSync(prefix);
  }

  String _generateUuidLikeIdSync(String prefix) {
    final random = Random();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final part1 = random.nextInt(0xFFFF).toRadixString(16).padLeft(4, '0');
    final part2 = random.nextInt(0xFFFF).toRadixString(16).padLeft(4, '0');
    final part3 = random.nextInt(0xFFFF).toRadixString(16).padLeft(4, '0');
    return '$prefix$timestamp-$part1-$part2-$part3';
  }

  Future<void> _batchPersist(EntityType? type) async {
    final futures = <Future>[];

    futures.add(_persistUsedIds());

    if (type != null) {
      switch (type) {
        case EntityType.trip:
          futures.add(_persistTripIds());
          break;
        case EntityType.item:
          futures.add(_persistItemIds());
          break;
        case EntityType.category:
          futures.add(_persistCategoryIds());
          break;
      }
    }

    await Future.wait(futures);
  }

  Future<void> _persistUsedIds() async {
    await _prefs!.setStringList(_usedIdsKey, _cachedUsedIds.toList());
  }

  Future<void> _persistTripIds() async {
    await _prefs!.setStringList(_tripIdsKey, _cachedTripIds.toList());
  }

  Future<void> _persistItemIds() async {
    await _prefs!.setStringList(_itemIdsKey, _cachedItemIds.toList());
  }

  Future<void> _persistCategoryIds() async {
    await _prefs!.setStringList(_categoryIdsKey, _cachedCategoryIds.toList());
  }

  Future<void> _persistCounters() async {
    final countersList =
        _counters.entries.map((e) => '${e.key}:${e.value}').toList();
    await _prefs!.setStringList(_countersKey, countersList);
  }

  void _schedulePeriodicCleanup() {
    // In a real app, you might want to schedule periodic cleanup
    // This is just a placeholder for the concept
  }
}

/// Enum for different ID generation strategies
enum IdGenerationStrategy {
  timestampRandom, // timestamp + random number (default)
  sequential, // timestamp + sequential counter
  uuid, // UUID-like format
}

/// Entity types for better organization
enum EntityType {
  trip,
  item,
  category,
}

/// Extension for batch operations
extension BatchOperations on UniqueIdService {
  /// Generate multiple trip IDs efficiently
  Future<List<String>> generateMultipleTripIds(
    int count, {
    IdGenerationStrategy strategy = IdGenerationStrategy.timestampRandom,
  }) async {
    return await generateBatchIds(
      count: count,
      prefix: 'trip_',
      type: EntityType.trip,
      strategy: strategy,
    );
  }

  /// Generate multiple item IDs efficiently
  Future<List<String>> generateMultipleItemIds(
    int count, {
    IdGenerationStrategy strategy = IdGenerationStrategy.timestampRandom,
  }) async {
    return await generateBatchIds(
      count: count,
      prefix: 'item_',
      type: EntityType.item,
      strategy: strategy,
    );
  }
}
