/// A value‐object wrapper around the raw ID of an Item.
class ItemId {
  final String value;

  /// Constructs an [ItemId]. Enforces that [value] is non‐empty.
  /// You can extend this to validate UUID format, length, etc.
  ItemId(this.value) {
    if (value.isEmpty) {
      throw ArgumentError.value(value, 'value', 'ItemId cannot be empty');
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemId &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'ItemId($value)';
}
