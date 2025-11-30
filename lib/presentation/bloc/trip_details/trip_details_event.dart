part of 'trip_details_bloc.dart';

abstract class TripDetailsEvent {
  const TripDetailsEvent();
}

class LoadTripDetails extends TripDetailsEvent {
  final String tripId;
  const LoadTripDetails(this.tripId);
}
