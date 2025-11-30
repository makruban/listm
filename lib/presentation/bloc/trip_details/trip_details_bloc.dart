import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listm/domain/entities/item_entity.dart';
import 'package:listm/domain/entities/trip_entity.dart';
import 'package:listm/domain/usecases/trip_item_usecases/get_items_for_trip_usecase.dart';
import 'package:listm/domain/usecases/trip_usecases/get_trip_by_id_usecase.dart';
import 'package:listm/domain/value_objects/trip_id.dart';

part 'trip_details_event.dart';
part 'trip_details_state.dart';

class TripDetailsBloc extends Bloc<TripDetailsEvent, TripDetailsState> {
  final GetTripByIdUseCase getTripByIdUseCase;
  final GetItemsForTripUseCase getItemsForTripUseCase;

  TripDetailsBloc({
    required this.getTripByIdUseCase,
    required this.getItemsForTripUseCase,
  }) : super(TripDetailsInitial()) {
    on<LoadTripDetails>(_onLoadTripDetails);
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
}
