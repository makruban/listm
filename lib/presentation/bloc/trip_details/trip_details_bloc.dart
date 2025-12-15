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
import 'package:listm/domain/usecases/trip_usecases/update_trip_usecase.dart';
import 'package:listm/domain/usecases/item_usecases/add_item_usecase.dart';
import 'package:listm/domain/usecases/item_usecases/get_items_stream_usecase.dart';
import 'package:listm/core/util/unique_id_service.dart';
import 'dart:async';

part 'trip_details_event.dart';
part 'trip_details_state.dart';

class TripDetailsBloc extends Bloc<TripDetailsEvent, TripDetailsState> {
  final GetTripByIdUseCase getTripByIdUseCase;
  final GetItemsForTripUseCase getItemsForTripUseCase;
  final GetItemsUsecase getItemsUsecase;
  final AddTripItemUseCase addTripItemUseCase;
  final RemoveTripItemUseCase removeTripItemUseCase;
  final UpdateTripUseCase updateTripUseCase;
  final AddItemUseCase addItemUseCase;
  final GetItemsStreamUseCase getItemsStreamUseCase;

  TripDetailsBloc({
    required this.getTripByIdUseCase,
    required this.getItemsForTripUseCase,
    required this.getItemsUsecase,
    required this.addTripItemUseCase,
    required this.removeTripItemUseCase,
    required this.updateTripUseCase,
    required this.addItemUseCase,
    required this.getItemsStreamUseCase,
  }) : super(TripDetailsInitial()) {
    on<LoadTripDetails>(_onLoadTripDetails);
    on<RemoveTripItem>(_onRemoveTripItem);
    on<UpdateTripTitle>(_onUpdateTripTitle);
  }

  @override
  Future<void> close() {
    return super.close();
  }

  Future<void> _onUpdateTripTitle(
    UpdateTripTitle event,
    Emitter<TripDetailsState> emit,
  ) async {
    final currentState = state;
    if (currentState is TripDetailsLoaded) {
      try {
        final updatedTrip = currentState.trip.copyWith(title: event.newTitle);
        await updateTripUseCase(updatedTrip);
        emit(currentState.copyWith(trip: updatedTrip));
      } catch (e) {
        emit(TripDetailsError(e.toString()));
      }
    }
  }

  Future<void> _onLoadTripDetails(
    LoadTripDetails event,
    Emitter<TripDetailsState> emit,
  ) async {
    emit(TripDetailsLoading());
    try {
      var trip = await getTripByIdUseCase(TripId(event.tripId));
      final items = await getItemsForTripUseCase(event.tripId);

      // Self-healing: Update item count if out of sync
      if (trip.itemCount != items.length) {
        trip = trip.copyWith(itemCount: items.length);
        await updateTripUseCase(trip);
      }

      emit(TripDetailsLoaded(trip: trip, items: items));
    } catch (e) {
      emit(TripDetailsError(e.toString()));
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

        final updatedTrip =
            currentState.trip.copyWith(itemCount: updatedItems.length);
        await updateTripUseCase(updatedTrip);

        emit(TripDetailsLoaded(
          trip: updatedTrip,
          items: updatedItems,
        ));
      } catch (e) {
        emit(TripDetailsError(e.toString()));
      }
    }
  }
}
