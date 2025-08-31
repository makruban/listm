import 'app_exception.dart';

/// Thrown when business rules or use-case logic fails.
class DomainException extends AppException {
  const DomainException(String message, [Object? cause])
      : super(message, cause);
}
