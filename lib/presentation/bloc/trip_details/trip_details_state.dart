part of 'trip_details_bloc.dart';

abstract class TripDetailsState {
  const TripDetailsState();
}

class TripDetailsInitial extends TripDetailsState {}

class TripDetailsLoading extends TripDetailsState {}

class TripDetailsLoaded extends TripDetailsState {
  final TripEntity trip;
  final List<ItemEntity> items;

  const TripDetailsLoaded({
    required this.trip,
    required this.items,
  });
}

class TripDetailsError extends TripDetailsState {
  final String message;
  const TripDetailsError(this.message);
}
