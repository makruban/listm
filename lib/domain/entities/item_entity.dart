import 'dart:convert';

/// Represents a single item in TripWise with its basic properties and JSON (de)serialization.
class ItemEntity {
  /// Unique identifier for the item.
  final String id;

  /// Title or name of the item (e.g., "Hat").
  final String title;

  /// Optional detailed description (e.g., "Wide-brimmed straw hat").
  final String description;

  /// Indicates whether the item has been marked as packed/completed.
  final bool isCompleted;

  /// Creates a new [ItemEntity].
  ///
  /// [id], [title], and [description] are required. [isCompleted]
  /// defaults to false when not specified.
  ItemEntity({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
  });
}
