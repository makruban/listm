part of 'trip_details_bloc.dart';

abstract class TripDetailsEvent {
  const TripDetailsEvent();
}

class LoadTripDetails extends TripDetailsEvent {
  final String tripId;
  const LoadTripDetails(this.tripId);
}

class RemoveTripItem extends TripDetailsEvent {
  final String itemId;
  const RemoveTripItem(this.itemId);
}

class UpdateTripTitle extends TripDetailsEvent {
  final String newTitle;
  const UpdateTripTitle(this.newTitle);
}

class ToggleTripItemCompletion extends TripDetailsEvent {
  final String itemId;
  const ToggleTripItemCompletion(this.itemId);
}
