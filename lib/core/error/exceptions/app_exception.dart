/// The root of all custom exceptions in TripWise.
class AppException implements Exception {
  /// A human-readable message describing the error.
  final String message;

  /// Optionally keep the original exception or stack trace.
  final Object? cause;

  const AppException(this.message, [this.cause]);

  @override
  String toString() => 'AppException: $message'
      '${cause != null ? ' (cause: $cause)' : ''}';
}
