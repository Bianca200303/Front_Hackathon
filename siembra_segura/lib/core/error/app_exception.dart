/// Errores tipados que la capa de datos expone al resto de la app.
///
/// Los repositorios traducen cualquier error técnico (HTTP, parseo, etc.)
/// a uno de estos tipos. La presentación nunca ve excepciones de librerías.
sealed class AppException implements Exception {
  const AppException([this.cause]);

  /// Error original, útil para logs. Nunca se muestra al usuario.
  final Object? cause;

  /// Traduce un código HTTP de error a una excepción de la app.
  ///
  /// Solo usa la semántica estándar de HTTP; el formato del cuerpo de error
  /// depende del backend (decisión pendiente B2).
  static AppException fromStatusCode(int statusCode, [Object? cause]) {
    return switch (statusCode) {
      401 || 403 => UnauthorizedException(cause),
      404 => NotFoundException(cause),
      408 => RequestTimeoutException(cause),
      >= 500 && < 600 => ServerException(statusCode, cause),
      _ => UnexpectedException(cause),
    };
  }

  @override
  String toString() => '$runtimeType(cause: $cause)';
}

final class NetworkException extends AppException {
  const NetworkException([super.cause]);
}

final class RequestTimeoutException extends AppException {
  const RequestTimeoutException([super.cause]);
}

final class UnauthorizedException extends AppException {
  const UnauthorizedException([super.cause]);
}

final class NotFoundException extends AppException {
  const NotFoundException([super.cause]);
}

final class ServerException extends AppException {
  const ServerException(this.statusCode, [super.cause]);

  final int statusCode;
}

final class UnexpectedException extends AppException {
  const UnexpectedException([super.cause]);
}
