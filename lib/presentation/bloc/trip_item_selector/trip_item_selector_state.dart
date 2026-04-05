part of 'trip_item_selector_bloc.dart';

abstract class TripItemSelectorState {}

class TripItemSelectorInitial extends TripItemSelectorState {}

class TripItemSelectorLoading extends TripItemSelectorState {}

class TripItemSelectorLoaded extends TripItemSelectorState {
  final List<ItemEntity> availableItems;
  final Set<String> selectedItemIds;
  final String tripId;
  final List<String> recentlyCreatedItemIds;
  final String searchQuery;

  TripItemSelectorLoaded({
    required this.availableItems,
    required this.selectedItemIds,
    required this.tripId,
    this.recentlyCreatedItemIds = const [],
    this.searchQuery = '',
  });

  List<ItemEntity> get filteredAvailableItems {
    if (searchQuery.isEmpty) return availableItems;
    final lowerQuery = searchQuery.toLowerCase();
    return availableItems
        .where((item) => item.title.toLowerCase().contains(lowerQuery))
        .toList();
  }

  TripItemSelectorLoaded copyWith({
    List<ItemEntity>? availableItems,
    Set<String>? selectedItemIds,
    String? tripId,
    List<String>? recentlyCreatedItemIds,
    String? searchQuery,
  }) {
    return TripItemSelectorLoaded(
      availableItems: availableItems ?? this.availableItems,
      selectedItemIds: selectedItemIds ?? this.selectedItemIds,
      tripId: tripId ?? this.tripId,
      recentlyCreatedItemIds: recentlyCreatedItemIds ?? this.recentlyCreatedItemIds,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class TripItemSelectorError extends TripItemSelectorState {
  final String message;
  TripItemSelectorError(this.message);
}
