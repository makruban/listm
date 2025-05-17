import 'package:bloc/bloc.dart';
import 'package:listm/domain/entities/trip_entity.dart';
import 'package:listm/domain/usecases/trip_usecases/add_trip_usecase.dart';
import 'package:listm/domain/usecases/trip_usecases/delete_all_trips_usecase.dart';
import 'package:listm/domain/usecases/trip_usecases/delete_trip_usecase.dart';
import 'package:listm/domain/usecases/trip_usecases/get_trip_by_id_usecase.dart';
import 'package:listm/domain/usecases/trip_usecases/get_trips_usecase.dart';
import 'package:listm/domain/usecases/trip_usecases/update_trip_usecase.dart';
import 'package:listm/domain/value_objects/no_params.dart';
import 'package:listm/domain/value_objects/trip_id.dart';

part 'trips_event.dart';
part 'trips_state.dart';

/// Business Logic Component for managing [TripEntity] objects.
class TripsBloc extends Bloc<TripsEvent, TripsState> {
  final GetTripsUseCase _getTripsUseCase;
  final GetTripByIdUseCase _getTripByIdUseCase;
  final AddTripUseCase _addTripUseCase;
  final UpdateTripUseCase _updateTripUseCase;
  final DeleteTripUseCase _deleteTripUseCase;
  final DeleteAllTripsUseCase _deleteAllTripsUseCase;

  TripsBloc({
    required GetTripsUseCase getTripsUseCase,
    required GetTripByIdUseCase getTripByIdUseCase,
    required AddTripUseCase addTripUseCase,
    required UpdateTripUseCase updateTripUseCase,
    required DeleteTripUseCase deleteTripUseCase,
    required DeleteAllTripsUseCase deleteAllTripsUseCase,
  })  : _getTripsUseCase = getTripsUseCase,
        _getTripByIdUseCase = getTripByIdUseCase,
        _addTripUseCase = addTripUseCase,
        _updateTripUseCase = updateTripUseCase,
        _deleteTripUseCase = deleteTripUseCase,
        _deleteAllTripsUseCase = deleteAllTripsUseCase,
        super(const TripsInitial()) {
    on<LoadTrips>(_onLoadTrips);
    on<GetTripByIdEvent>(_onGetTripById);
    on<AddTripEvent>(_onAddTrip);
    on<UpdateTripEvent>(_onUpdateTrip);
    on<RemoveTripEvent>(_onRemoveTrip);
    on<DeleteAllTripsEvent>(_onDeleteAllTrips);
  }

  Future<void> _onLoadTrips(LoadTrips event, Emitter<TripsState> emit) async {
    emit(const TripsLoadInProgress());
    try {
      final trips = await _getTripsUseCase(const NoParams());
      emit(TripsLoadSuccess(trips));
    } catch (e) {
      emit(TripsFailure(e.toString()));
    }
  }

  Future<void> _onGetTripById(
      GetTripByIdEvent event, Emitter<TripsState> emit) async {
    emit(const TripsLoadInProgress());
    try {
      final trip = await _getTripByIdUseCase(event.id);
      emit(TripLoadSuccess(trip));
    } catch (e) {
      emit(TripsFailure(e.toString()));
    }
  }

  Future<void> _onAddTrip(AddTripEvent event, Emitter<TripsState> emit) async {
    try {
      await _addTripUseCase(event.trip);
      add(const LoadTrips());
    } catch (e) {
      emit(TripsFailure(e.toString()));
    }
  }

  Future<void> _onUpdateTrip(
      UpdateTripEvent event, Emitter<TripsState> emit) async {
    try {
      await _updateTripUseCase(event.trip);
      add(const LoadTrips());
    } catch (e) {
      emit(TripsFailure(e.toString()));
    }
  }

  Future<void> _onRemoveTrip(
      RemoveTripEvent event, Emitter<TripsState> emit) async {
    try {
      await _deleteTripUseCase(event.id);
      add(const LoadTrips());
    } catch (e) {
      emit(TripsFailure(e.toString()));
    }
  }

  Future<void> _onDeleteAllTrips(
      DeleteAllTripsEvent event, Emitter<TripsState> emit) async {
    try {
      await _deleteAllTripsUseCase(const NoParams());
      add(const LoadTrips());
    } catch (e) {
      emit(TripsFailure(e.toString()));
    }
  }
}
