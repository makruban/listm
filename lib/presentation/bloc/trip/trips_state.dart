part of 'trips_bloc.dart';

/// Base class for all trip-related states.
abstract class TripsState {
  const TripsState();
}

/// Initial state before any actions have taken place.
class TripsInitial extends TripsState {
  const TripsInitial();
}

/// State while trips are being loaded.
class TripsLoadInProgress extends TripsState {
  const TripsLoadInProgress();
}

/// State when a list of trips has been successfully loaded.
class TripsLoadSuccess extends TripsState {
  final List<TripEntity> trips;
  const TripsLoadSuccess(this.trips);
}

/// State when a single trip has been successfully loaded.
class TripLoadSuccess extends TripsState {
  final TripEntity trip;
  const TripLoadSuccess(this.trip);
}

/// State when any operation (load, add, update, delete) fails.
class TripsFailure extends TripsState {
  final String error;
  const TripsFailure(this.error);
}
