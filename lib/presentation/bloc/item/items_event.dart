part of 'items_bloc.dart';

/// Base class for all item-related events.
abstract class ItemsEvent {
  const ItemsEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all items.
class LoadItems extends ItemsEvent {
  const LoadItems();
}

/// Event to load a single item by its [id].
class GetItemByIdEvent extends ItemsEvent {
  final ItemId id;
  const GetItemByIdEvent(this.id);

  @override
  List<Object?> get props => [id];
}

/// Event to add a new item.
class AddItemEvent extends ItemsEvent {
  final ItemEntity item;
  const AddItemEvent(this.item);

  @override
  List<Object?> get props => [item];
}

/// Event to update an existing item.
class UpdateItemEvent extends ItemsEvent {
  final ItemEntity item;
  const UpdateItemEvent(this.item);

  @override
  List<Object?> get props => [item];
}

/// Event to remove an item by its [id].
class RemoveItemEvent extends ItemsEvent {
  final ItemId id;
  const RemoveItemEvent(this.id);
}
