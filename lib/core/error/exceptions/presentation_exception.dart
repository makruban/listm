import 'app_exception.dart';

/// Thrown for UI‐specific errors (validation, navigation failures, etc.).
class PresentationException extends AppException {
  const PresentationException(String message, [Object? cause])
      : super(message, cause);
}
