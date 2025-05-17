import 'package:flutter_bloc/flutter_bloc.dart';

part 'packing_lists_event.dart';
part 'packing_lists_state.dart';

class PackingListsBloc extends Bloc<PackingListsEvent, PackingListsState> {
  PackingListsBloc() : super(TripsLoadInProgress()) {
    on<LoadTrips>((_, emit) async {
      emit(TripsLoadInProgress());
      final trips = await _getTrips.execute();
      emit(TripsLoadSuccess(trips));
    });

    on<AddTrip>((event, emit) async {
      await _addTrip.execute(event.trip);
      add(LoadTrips());
    });

    on<RemoveTrip>((event, emit) async {
      await _removeTrip.execute(event.id);
      add(LoadTrips());
    });
  }
}
