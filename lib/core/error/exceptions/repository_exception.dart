import 'app_exception.dart';

/// Thrown when a repository (I/O, cache, JSON) fails.
class RepositoryException extends AppException {
  const RepositoryException(String message, [Object? cause])
      : super(message, cause);
}

/// Thrown when a repository fails to load data.
class RepositoryLoadException extends RepositoryException {
  const RepositoryLoadException(String message, [Object? cause])
      : super(message, cause);
}

/// Thrown when a repository fails to save data.
class RepositorySaveException extends RepositoryException {
  const RepositorySaveException(String message, [Object? cause])
      : super(message, cause);
}

/// Thrown when a repository fails to delete data.
class RepositoryDeleteException extends RepositoryException {
  const RepositoryDeleteException(String message, [Object? cause])
      : super(message, cause);
}

/// Thrown when a repository fails to update data.
class RepositoryUpdateException extends RepositoryException {
  const RepositoryUpdateException(String message, [Object? cause])
      : super(message, cause);
}

/// Thrown when a repository fails to find data.
class RepositoryNotFoundException extends RepositoryException {
  const RepositoryNotFoundException(String message, [Object? cause])
      : super(message, cause);
}

/// Thrown when a repository fails to parse data.
class RepositoryParseException extends RepositoryException {
  const RepositoryParseException(String message, [Object? cause])
      : super(message, cause);
}
