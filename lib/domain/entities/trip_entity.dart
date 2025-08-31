// lib/domain/entities/trip_entity.dart

import 'dart:convert';

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

  /// Constructs a new [TripEntity].
  ///
  /// All fields are required and cannot be null.
  TripEntity({
    required this.id,
    required this.title,
    required this.icon,
    required this.itemCount,
  });
}
