part of 'trip_details_bloc.dart';

abstract class TripDetailsState {
  const TripDetailsState();
}

class TripDetailsInitial extends TripDetailsState {}

class TripDetailsLoading extends TripDetailsState {}

class TripDetailsLoaded extends TripDetailsState {
  final TripEntity trip;
  final List<ItemEntity> items;
  final List<ItemEntity> availableItems;

  const TripDetailsLoaded({
    required this.trip,
    required this.items,
    this.availableItems = const [],
  });

  TripDetailsLoaded copyWith({
    TripEntity? trip,
    List<ItemEntity>? items,
    List<ItemEntity>? availableItems,
  }) {
    return TripDetailsLoaded(
      trip: trip ?? this.trip,
      items: items ?? this.items,
      availableItems: availableItems ?? this.availableItems,
    );
  }
}

class TripDetailsError extends TripDetailsState {
  final String message;
  const TripDetailsError(this.message);
}
