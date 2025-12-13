part of 'trip_details_bloc.dart';

abstract class TripDetailsEvent {
  const TripDetailsEvent();
}

class LoadTripDetails extends TripDetailsEvent {
  final String tripId;
  const LoadTripDetails(this.tripId);
}

class LoadAvailableItems extends TripDetailsEvent {}

class AddTripItem extends TripDetailsEvent {
  final String itemId;
  const AddTripItem(this.itemId);
}

class RemoveTripItem extends TripDetailsEvent {
  final String itemId;
  const RemoveTripItem(this.itemId);
}

class UpdateTripTitle extends TripDetailsEvent {
  final String newTitle;
  const UpdateTripTitle(this.newTitle);
}
