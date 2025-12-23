class TripItemRelationEntity {
  final String tripId;
  final String itemId;
  final bool isCompleted;

  const TripItemRelationEntity({
    required this.tripId,
    required this.itemId,
    this.isCompleted = false,
  });
}
