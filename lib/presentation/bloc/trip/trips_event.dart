part of 'trips_bloc.dart';

/// Base class for all trip-related events.
abstract class TripsEvent {
  const TripsEvent();
}

/// Event to load all trips.
class LoadTrips extends TripsEvent {
  const LoadTrips();
}

/// Event to load a single trip by its [id].
class GetTripByIdEvent extends TripsEvent {
  final TripId id;
  const GetTripByIdEvent(this.id);
}

/// Event to add a new trip.
class AddTripEvent extends TripsEvent {
  final String id;
  const AddTripEvent({required this.id});
}

/// Event to update an existing trip.
class UpdateTripEvent extends TripsEvent {
  final TripEntity trip;
  const UpdateTripEvent(this.trip);
}

/// Event to remove a trip by its [id].
class RemoveTripEvent extends TripsEvent {
  final TripId id;
  const RemoveTripEvent(this.id);
}

/// Event to delete all trips.
class DeleteAllTripsEvent extends TripsEvent {
  const DeleteAllTripsEvent();
}

/// Event to subscribe to the trips stream.
class SubscribeToTrips extends TripsEvent {
  const SubscribeToTrips();
}
