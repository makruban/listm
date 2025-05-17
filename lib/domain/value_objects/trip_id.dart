// This file defines the ItemId value object, which is used to uniquely identify
class TripId {
  final String value;

  /// Constructs an [TripId]. Enforces that [value] is non‐empty.
  TripId(this.value) {
    if (value.isEmpty) {
      throw ArgumentError.value(value, 'value', 'TripId cannot be empty');
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TripId &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'ItemId($value)';
}
