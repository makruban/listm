import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listm/core/util/unique_id_service.dart';
import 'package:listm/domain/entities/item_entity.dart';
import 'package:listm/domain/usecases/item_usecases/add_item_usecase.dart';
import 'package:listm/domain/usecases/item_usecases/get_items_usecase.dart';
import 'package:listm/domain/usecases/item_usecases/get_items_stream_usecase.dart';
import 'package:listm/domain/usecases/trip_item_usecases/add_trip_item_usecase.dart';
import 'package:listm/domain/usecases/trip_item_usecases/get_items_for_trip_usecase.dart';
import 'package:listm/domain/usecases/trip_item_usecases/remove_trip_item_usecase.dart';
import 'package:listm/domain/value_objects/no_params.dart';
import 'package:listm/domain/usecases/trip_usecases/get_trip_by_id_usecase.dart';
import 'package:listm/domain/usecases/trip_usecases/update_trip_usecase.dart';
import 'package:listm/domain/value_objects/trip_id.dart';

part 'trip_item_selector_event.dart';
part 'trip_item_selector_state.dart';

class TripItemSelectorBloc
    extends Bloc<TripItemSelectorEvent, TripItemSelectorState> {
  final GetItemsStreamUseCase getItemsStreamUseCase;
  final GetItemsForTripUseCase getItemsForTripUseCase;
  final AddTripItemUseCase addTripItemUseCase;
  final RemoveTripItemUseCase removeTripItemUseCase;
  final AddItemUseCase addItemUseCase;
  final GetItemsUsecase getItemsUseCase;
  final GetTripByIdUseCase getTripByIdUseCase;
  final UpdateTripUseCase updateTripUseCase;

  StreamSubscription<List<ItemEntity>>? _itemsSubscription;

  TripItemSelectorBloc({
    required this.getItemsStreamUseCase,
    required this.getItemsForTripUseCase,
    required this.addTripItemUseCase,
    required this.removeTripItemUseCase,
    required this.addItemUseCase,
    required this.getItemsUseCase,
    required this.getTripByIdUseCase,
    required this.updateTripUseCase,
  }) : super(TripItemSelectorInitial()) {
    on<LoadTripItemSelector>(_onLoadTripItemSelector);
    on<AvailableItemsUpdated>(_onAvailableItemsUpdated);
    on<ToggleItemSelection>(_onToggleItemSelection);
    on<CreateAndSelectNewItem>(_onCreateAndSelectNewItem);
  }

  @override
  Future<void> close() {
    _itemsSubscription?.cancel();
    return super.close();
  }

  Future<void> _onLoadTripItemSelector(
    LoadTripItemSelector event,
    Emitter<TripItemSelectorState> emit,
  ) async {
    emit(TripItemSelectorLoading());
    try {
      // Load initial selected items for this trip
      final tripItems = await getItemsForTripUseCase(event.tripId);
      final selectedIds = tripItems.map((e) => e.item.id).toSet();

      // Subscribe to available items stream
      _itemsSubscription?.cancel();
      final stream = await getItemsStreamUseCase(NoParams());
      _itemsSubscription = stream.listen((items) {
        add(AvailableItemsUpdated(items));
      });

      // We don't have the full list yet, waiting for stream update or we can fetch once if needed.
      // Assuming stream emits immediately upon listen (BehaviourSubject-like) or we wait.
      // But commonly we might want to fetch initial list too if stream doesn't replay.
      // For now, let's wait for the stream event.
      // However, to avoid being stuck in Loading if stream is empty/silent:
      // In this app structure, stream usually emits current value content immediately if implemented with BehaviorSubject or similar.
      // Let's assume it does, but we can emit an empty loaded state just in case.
      // Load initial available items
      final initialAvailableItems = await getItemsUseCase(NoParams());

      emit(TripItemSelectorLoaded(
        availableItems: initialAvailableItems,
        selectedItemIds: selectedIds,
        tripId: event.tripId,
      ));
    } catch (e) {
      emit(TripItemSelectorError(e.toString()));
    }
  }

  void _onAvailableItemsUpdated(
    AvailableItemsUpdated event,
    Emitter<TripItemSelectorState> emit,
  ) {
    if (state is TripItemSelectorLoaded) {
      final currentState = state as TripItemSelectorLoaded;

      final sortedItems = List<ItemEntity>.from(event.items);
      sortedItems.sort((a, b) {
        final indexA = currentState.recentlyCreatedItemIds.indexOf(a.id);
        final indexB = currentState.recentlyCreatedItemIds.indexOf(b.id);

        if (indexA != -1 && indexB != -1) {
          return indexA.compareTo(indexB);
        } else if (indexA != -1) {
          return -1;
        } else if (indexB != -1) {
          return 1;
        }
        return 0;
      });

      emit(currentState.copyWith(
        availableItems: sortedItems,
      ));
    }
  }

  Future<void> _onToggleItemSelection(
    ToggleItemSelection event,
    Emitter<TripItemSelectorState> emit,
  ) async {
    final currentState = state;
    if (currentState is TripItemSelectorLoaded) {
      final currentSelectedIds = Set<String>.from(currentState.selectedItemIds);

      // Optimistic update
      if (event.isSelected) {
        currentSelectedIds.add(event.itemId);
      } else {
        currentSelectedIds.remove(event.itemId);
      }

      emit(currentState.copyWith(selectedItemIds: currentSelectedIds));

      try {
        if (event.isSelected) {
          await addTripItemUseCase(AddTripItemParams(
            tripId: currentState.tripId,
            itemId: event.itemId,
          ));
        } else {
          await removeTripItemUseCase(RemoveTripItemParams(
            tripId: currentState.tripId,
            itemId: event.itemId,
          ));
        }

        // Sync trip item count
        final updatedItems = await getItemsForTripUseCase(currentState.tripId);
        final trip = await getTripByIdUseCase(TripId(currentState.tripId));
        final completedCount = updatedItems.where((i) => i.isCompleted).length;
        final updatedTrip = trip.copyWith(
          itemCount: updatedItems.length,
          completedItemCount: completedCount,
        );
        await updateTripUseCase(updatedTrip);
      } catch (e) {
        // Revert on failure
        if (event.isSelected) {
          currentSelectedIds.remove(event.itemId);
        } else {
          currentSelectedIds.add(event.itemId);
        }
        emit(currentState.copyWith(selectedItemIds: currentSelectedIds));
        // Maybe emit a side-effect error? keeping it simple for now
      }
    }
  }

  Future<void> _onCreateAndSelectNewItem(
    CreateAndSelectNewItem event,
    Emitter<TripItemSelectorState> emit,
  ) async {
    final currentState = state;
    if (currentState is TripItemSelectorLoaded) {
      try {
        final newItemId = await UniqueIdService.instance
            .generateItemId(strategy: IdGenerationStrategy.uuid);

        final newItem = ItemEntity(
          id: newItemId,
          title: event.name,
          description: '',
        );

        // Optimistically update selection and availableItems before async work
        final currentSelectedIds =
            Set<String>.from(currentState.selectedItemIds);
        currentSelectedIds.add(newItemId);

        final currentRecentlyCreated =
            List<String>.from(currentState.recentlyCreatedItemIds);
        currentRecentlyCreated.insert(0, newItemId);

        final currentAvailableItems =
            List<ItemEntity>.from(currentState.availableItems);
        currentAvailableItems.insert(0, newItem);

        emit(currentState.copyWith(
          selectedItemIds: currentSelectedIds,
          availableItems: currentAvailableItems,
          recentlyCreatedItemIds: currentRecentlyCreated,
        ));

        // 1. Add item globally
        await addItemUseCase(newItem);

        // 2. Add to trip
        await addTripItemUseCase(AddTripItemParams(
          tripId: currentState.tripId,
          itemId: newItemId,
        ));

        // Sync trip item count
        final updatedItems = await getItemsForTripUseCase(currentState.tripId);
        final trip = await getTripByIdUseCase(TripId(currentState.tripId));
        final completedCount = updatedItems.where((i) => i.isCompleted).length;
        final updatedTrip = trip.copyWith(
          itemCount: updatedItems.length,
          completedItemCount: completedCount,
        );
        await updateTripUseCase(updatedTrip);
      } catch (e) {
        emit(TripItemSelectorError(e.toString()));
      }
    }
  }
}
