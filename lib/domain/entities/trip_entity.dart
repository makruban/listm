/// Represents a packing trip, containing its identifier, title, icon reference, and the count of items packed.
class TripEntity {
  /// Unique identifier for the trip.
  final String id;

  /// Display title of the trip (e.g., "Lake Trip").
  final String title;

  /// Asset path or icon name used to visually represent the trip.
  final String icon;

  /// Number of items currently in this trip's packing list.
  final int itemCount;

  /// Number of items in this trip that have been marked as completed (packed).
  final int completedItemCount;

  /// Constructs a new [TripEntity].
  ///
  /// All fields are required and cannot be null.
  TripEntity({
    required this.id,
    required this.title,
    required this.icon,
    required this.itemCount,
    this.completedItemCount = 0,
  });

  TripEntity copyWith({
    String? id,
    String? title,
    String? icon,
    int? itemCount,
    int? completedItemCount,
  }) {
    return TripEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      itemCount: itemCount ?? this.itemCount,
      completedItemCount: completedItemCount ?? this.completedItemCount,
    );
  }
}
