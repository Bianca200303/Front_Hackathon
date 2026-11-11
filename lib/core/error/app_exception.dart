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

/// Sin conexión a internet.
final class NetworkException extends AppException {
  /// Crea el error, con la causa original opcional.
  const NetworkException([super.cause]);
}

/// El servidor tardó demasiado en responder.
final class RequestTimeoutException extends AppException {
  /// Crea el error, con la causa original opcional.
  const RequestTimeoutException([super.cause]);
}

/// Sesión vencida o sin permiso (HTTP 401/403).
final class UnauthorizedException extends AppException {
  /// Crea el error, con la causa original opcional.
  const UnauthorizedException([super.cause]);
}

/// El recurso pedido no existe (HTTP 404).
final class NotFoundException extends AppException {
  /// Crea el error, con la causa original opcional.
  const NotFoundException([super.cause]);
}

/// Error del servidor (HTTP 5xx u otro código inesperado).
final class ServerException extends AppException {
  /// Crea el error con el código HTTP recibido.
  const ServerException(this.statusCode, [super.cause]);

  /// Código HTTP de la respuesta.
  final int statusCode;
}

/// Cualquier otro error no previsto.
final class UnexpectedException extends AppException {
  /// Crea el error, con la causa original opcional.
  const UnexpectedException([super.cause]);
}
