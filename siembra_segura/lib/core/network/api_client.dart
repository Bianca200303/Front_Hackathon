import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:siembra_segura/core/config/app_config.dart';

/// Contrato mínimo del cliente HTTP que usarán las fuentes de datos remotas.
///
/// Todavía no tiene implementación: el cliente concreto (previsiblemente
/// basado en `dio`) se añade cuando el backend defina contratos,
/// autenticación y formato de errores (decisiones B1 y B2).
///
/// Toda implementación debe traducir sus errores a `AppException`.
abstract interface class ApiClient {
  Future<Object?> get(String path, {Map<String, String>? query});

  Future<Object?> post(String path, {Object? body});
}

/// Resuelve rutas relativas contra la URL base del entorno.
///
/// Las rutas concretas de cada recurso se definirán junto con el backend;
/// no se inventan aquí.
class ApiEndpoints {
  const ApiEndpoints(this.baseUrl);

  final Uri baseUrl;

  Uri resolve(String path, [Map<String, String>? query]) {
    final resolved = baseUrl.resolve(path);
    return query == null ? resolved : resolved.replace(queryParameters: query);
  }
}

final apiEndpointsProvider = Provider<ApiEndpoints>((ref) {
  final baseUrl = ref.watch(appConfigProvider).apiBaseUrl;
  if (baseUrl == null) {
    throw StateError('API_BASE_URL no está configurada para este entorno.');
  }
  return ApiEndpoints(baseUrl);
});
