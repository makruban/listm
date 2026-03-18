part of 'trip_item_selector_bloc.dart';

abstract class TripItemSelectorState {}

class TripItemSelectorInitial extends TripItemSelectorState {}

class TripItemSelectorLoading extends TripItemSelectorState {}

class TripItemSelectorLoaded extends TripItemSelectorState {
  final List<ItemEntity> availableItems;
  final Set<String> selectedItemIds;
  final String tripId;
  final List<String> recentlyCreatedItemIds;

  TripItemSelectorLoaded({
    required this.availableItems,
    required this.selectedItemIds,
    required this.tripId,
    this.recentlyCreatedItemIds = const [],
  });

  TripItemSelectorLoaded copyWith({
    List<ItemEntity>? availableItems,
    Set<String>? selectedItemIds,
    String? tripId,
    List<String>? recentlyCreatedItemIds,
  }) {
    return TripItemSelectorLoaded(
      availableItems: availableItems ?? this.availableItems,
      selectedItemIds: selectedItemIds ?? this.selectedItemIds,
      tripId: tripId ?? this.tripId,
      recentlyCreatedItemIds: recentlyCreatedItemIds ?? this.recentlyCreatedItemIds,
    );
  }
}

class TripItemSelectorError extends TripItemSelectorState {
  final String message;
  TripItemSelectorError(this.message);
}
