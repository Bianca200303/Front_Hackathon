import 'package:flutter_test/flutter_test.dart';
import 'package:siembra_segura/core/error/app_exception.dart';
import 'package:siembra_segura/core/error/error_messages.dart';
import 'package:siembra_segura/core/l10n/app_localizations_es.dart';

void main() {
  group('AppException.fromStatusCode', () {
    test('traduce códigos HTTP estándar', () {
      expect(AppException.fromStatusCode(401), isA<UnauthorizedException>());
      expect(AppException.fromStatusCode(403), isA<UnauthorizedException>());
      expect(AppException.fromStatusCode(404), isA<NotFoundException>());
      expect(AppException.fromStatusCode(408), isA<RequestTimeoutException>());
      expect(
        AppException.fromStatusCode(503),
        isA<ServerException>().having((e) => e.statusCode, 'statusCode', 503),
      );
      expect(AppException.fromStatusCode(418), isA<UnexpectedException>());
    });
  });

  group('userMessageFor', () {
    final l10n = AppLocalizationsEs();

    test('da un mensaje específico por tipo', () {
      expect(userMessageFor(const NetworkException(), l10n), l10n.errorNetwork);
      expect(
        userMessageFor(const ServerException(500), l10n),
        l10n.errorServer,
      );
    });

    test('usa un mensaje genérico para errores desconocidos', () {
      expect(userMessageFor(StateError('x'), l10n), l10n.errorUnexpected);
    });
  });
}
