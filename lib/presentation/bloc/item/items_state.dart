part of 'items_bloc.dart';

/// Base class for all item-related states.
abstract class ItemsState {
  const ItemsState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any actions have taken place.
class ItemsInitial extends ItemsState {
  const ItemsInitial();
}

/// State while items are being loaded.
class ItemsLoadInProgress extends ItemsState {
  const ItemsLoadInProgress();
}

/// State when a list of items has been successfully loaded.
class ItemsLoadSuccess extends ItemsState {
  final List<ItemEntity> items;
  const ItemsLoadSuccess(this.items);

  @override
  List<Object?> get props => [items];
}

/// State when a single item has been successfully loaded.
class ItemLoadSuccess extends ItemsState {
  final ItemEntity item;
  const ItemLoadSuccess(this.item);

  @override
  List<Object?> get props => [item];
}

/// State when any operation (load, add, update, delete) fails.
class ItemsFailure extends ItemsState {
  final String error;
  const ItemsFailure(this.error);
}
