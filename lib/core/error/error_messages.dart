import 'package:siembra_segura/core/error/app_exception.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';

/// Mensaje legible para el usuario a partir de cualquier error.
String userMessageFor(Object error, AppLocalizations l10n) {
  if (error is! AppException) return l10n.errorUnexpected;
  return switch (error) {
    NetworkException() => l10n.errorNetwork,
    RequestTimeoutException() => l10n.errorTimeout,
    UnauthorizedException() => l10n.errorUnauthorized,
    NotFoundException() => l10n.errorNotFound,
    ServerException() => l10n.errorServer,
    UnexpectedException() => l10n.errorUnexpected,
  };
}
