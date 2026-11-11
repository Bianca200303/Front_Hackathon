import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siembra_segura/core/error/app_exception.dart';
import 'package:siembra_segura/core/network/retry_policy.dart';
import 'package:siembra_segura/core/utils/async_value_combine.dart';

void main() {
  int sum(int a, int b) => a + b;

  group('combineAsync', () {
    test('combina dos valores', () {
      expect(
        combineAsync(const AsyncData(1), const AsyncData(2), sum).value,
        3,
      );
    });

    test('propaga el primer error', () {
      final result = combineAsync(
        const AsyncData(1),
        const AsyncError<int>(NetworkException(), StackTrace.empty),
        sum,
      );
      expect(result.error, isA<NetworkException>());
    });

    test('espera mientras alguno carga', () {
      expect(
        combineAsync(const AsyncData(1), const AsyncLoading<int>(), sum),
        isA<AsyncLoading<int>>(),
      );
    });

    test('convierte en error una excepción al combinar', () {
      final result = combineAsync<int, int, int>(
        const AsyncData(1),
        const AsyncData(2),
        (_, _) => throw StateError('x'),
      );
      expect(result.error, isA<StateError>());
    });
  });

  group('retryTransientErrors', () {
    test('reintenta errores de conexión con espera creciente', () {
      expect(
        retryTransientErrors(0, const NetworkException()),
        const Duration(seconds: 1),
      );
      expect(
        retryTransientErrors(2, const RequestTimeoutException()),
        const Duration(seconds: 4),
      );
      expect(retryTransientErrors(3, const NetworkException()), isNull);
    });

    test('no reintenta errores que no son transitorios', () {
      expect(retryTransientErrors(0, const NotFoundException()), isNull);
      expect(retryTransientErrors(0, const ServerException(500)), isNull);
      expect(retryTransientErrors(0, StateError('x')), isNull);
    });
  });
}
