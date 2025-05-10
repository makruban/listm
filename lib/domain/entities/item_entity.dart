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

  /// Creates an [ItemEntity] from a JSON map.
  ///
  /// Expects keys: 'id', 'title', 'description', 'isCompleted'.
  factory ItemEntity.fromJson(Map<String, dynamic> json) {
    return ItemEntity(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      isCompleted: json['isCompleted'] as bool,
    );
  }

  /// Converts this [ItemEntity] into a JSON map.
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'isCompleted': isCompleted,
      };

  @override
  String toString() => jsonEncode(toJson());
}
