import 'package:listm/domain/entities/item_entity.dart';

class TripDetailItem {
  final ItemEntity item;
  final bool isCompleted;

  const TripDetailItem({
    required this.item,
    this.isCompleted = false,
  });

  TripDetailItem copyWith({
    ItemEntity? item,
    bool? isCompleted,
  }) {
    return TripDetailItem(
      item: item ?? this.item,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
