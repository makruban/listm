import 'package:listm/domain/entities/item_entity.dart';
import 'package:flutter/foundation.dart';

class ItemViewModel {
  final ItemEntity item;
  final List<String> tripNames;

  const ItemViewModel({
    required this.item,
    this.tripNames = const [],
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemViewModel &&
          runtimeType == other.runtimeType &&
          item == other.item &&
          listEquals(tripNames, other.tripNames);

  @override
  int get hashCode => item.hashCode ^ tripNames.hashCode;
}
