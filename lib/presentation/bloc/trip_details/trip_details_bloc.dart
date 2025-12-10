import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listm/domain/entities/item_entity.dart';
import 'package:listm/domain/entities/trip_entity.dart';
import 'package:listm/domain/usecases/trip_item_usecases/get_items_for_trip_usecase.dart';
import 'package:listm/domain/usecases/trip_usecases/get_trip_by_id_usecase.dart';
import 'package:listm/domain/usecases/item_usecases/get_items_usecase.dart';
import 'package:listm/domain/value_objects/no_params.dart';
import 'package:listm/domain/value_objects/trip_id.dart';

import 'package:listm/domain/usecases/trip_item_usecases/add_trip_item_usecase.dart';
import 'package:listm/domain/usecases/trip_item_usecases/remove_trip_item_usecase.dart';

part 'trip_details_event.dart';
part 'trip_details_state.dart';

class TripDetailsBloc extends Bloc<TripDetailsEvent, TripDetailsState> {
  final GetTripByIdUseCase getTripByIdUseCase;
  final GetItemsForTripUseCase getItemsForTripUseCase;
  final GetItemsUsecase getItemsUsecase;
  final AddTripItemUseCase addTripItemUseCase;
  final RemoveTripItemUseCase removeTripItemUseCase;

  TripDetailsBloc({
    required this.getTripByIdUseCase,
    required this.getItemsForTripUseCase,
    required this.getItemsUsecase,
    required this.addTripItemUseCase,
    required this.removeTripItemUseCase,
  }) : super(TripDetailsInitial()) {
    on<LoadTripDetails>(_onLoadTripDetails);
    on<LoadAvailableItems>(_onLoadAvailableItems);
    on<AddTripItem>(_onAddTripItem);
    on<RemoveTripItem>(_onRemoveTripItem);
  }

  Future<void> _onLoadTripDetails(
    LoadTripDetails event,
    Emitter<TripDetailsState> emit,
  ) async {
    emit(TripDetailsLoading());
    try {
      final trip = await getTripByIdUseCase(TripId(event.tripId));
      final items = await getItemsForTripUseCase(event.tripId);

      emit(TripDetailsLoaded(trip: trip, items: items));
    } catch (e) {
      emit(TripDetailsError(e.toString()));
    }
  }

  Future<void> _onLoadAvailableItems(
    LoadAvailableItems event,
    Emitter<TripDetailsState> emit,
  ) async {
    final currentState = state;
    if (currentState is TripDetailsLoaded) {
      try {
        final availableItems = await getItemsUsecase(NoParams());
        emit(TripDetailsLoaded(
          trip: currentState.trip,
          items: currentState.items,
          availableItems: availableItems,
        ));
      } catch (e) {
        emit(TripDetailsError(e.toString()));
      }
    }
  }

  Future<void> _onAddTripItem(
    AddTripItem event,
    Emitter<TripDetailsState> emit,
  ) async {
    final currentState = state;
    if (currentState is TripDetailsLoaded) {
      try {
        await addTripItemUseCase(AddTripItemParams(
          tripId: currentState.trip.id,
          itemId: event.itemId,
        ));

        final updatedItems = await getItemsForTripUseCase(currentState.trip.id);

        emit(TripDetailsLoaded(
          trip: currentState.trip,
          items: updatedItems,
          availableItems: currentState.availableItems,
        ));
      } catch (e) {
        emit(TripDetailsError(e.toString()));
      }
    }
  }

  Future<void> _onRemoveTripItem(
    RemoveTripItem event,
    Emitter<TripDetailsState> emit,
  ) async {
    final currentState = state;
    if (currentState is TripDetailsLoaded) {
      try {
        await removeTripItemUseCase(RemoveTripItemParams(
          tripId: currentState.trip.id,
          itemId: event.itemId,
        ));

        final updatedItems = await getItemsForTripUseCase(currentState.trip.id);

        emit(TripDetailsLoaded(
          trip: currentState.trip,
          items: updatedItems,
          availableItems: currentState.availableItems,
        ));
      } catch (e) {
        emit(TripDetailsError(e.toString()));
      }
    }
  }
}
