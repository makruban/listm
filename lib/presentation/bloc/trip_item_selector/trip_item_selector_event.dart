part of 'trip_item_selector_bloc.dart';

abstract class TripItemSelectorEvent {}

class LoadTripItemSelector extends TripItemSelectorEvent {
  final String tripId;
  LoadTripItemSelector(this.tripId);
}

class ToggleItemSelection extends TripItemSelectorEvent {
  final String itemId;
  final bool isSelected;
  ToggleItemSelection(this.itemId, this.isSelected);
}

class CreateAndSelectNewItem extends TripItemSelectorEvent {
  final String name;
  CreateAndSelectNewItem(this.name);
}

class AvailableItemsUpdated extends TripItemSelectorEvent {
  final List<ItemEntity> items;
  AvailableItemsUpdated(this.items);
}

class SearchQueryChanged extends TripItemSelectorEvent {
  final String query;
  SearchQueryChanged(this.query);
}

