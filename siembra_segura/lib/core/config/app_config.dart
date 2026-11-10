import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Environment { dev, staging, prod }

/// Origen de los datos de los repositorios.
///
/// `mock` usa datos locales de ejemplo; `remote` usará el backend cuando
/// existan los contratos (ver docs/ARCHITECTURE.md, decisión B2).
enum DataSourceMode { mock, remote }

/// Configuración de la app, inyectada en tiempo de compilación con
/// `--dart-define-from-file=config/<entorno>.json`.
class AppConfig extends Equatable {
  const AppConfig({
    required this.environment,
    required this.dataSource,
    this.apiBaseUrl,
  });

  factory AppConfig.fromEnvironment() => AppConfig.parse(
    environment: const String.fromEnvironment('APP_ENV', defaultValue: 'dev'),
    dataSource: const String.fromEnvironment(
      'DATA_SOURCE',
      defaultValue: 'mock',
    ),
    apiBaseUrl: const String.fromEnvironment('API_BASE_URL'),
  );

  /// Construye y valida la configuración a partir de valores en texto.
  ///
  /// Lanza [ArgumentError] si algún valor es inválido, para fallar al
  /// arrancar en lugar de hacerlo en mitad de una petición.
  factory AppConfig.parse({
    required String environment,
    required String dataSource,
    String apiBaseUrl = '',
  }) {
    final env = Environment.values.asNameMap()[environment];
    if (env == null) {
      throw ArgumentError.value(environment, 'APP_ENV', 'Entorno desconocido');
    }
    final mode = DataSourceMode.values.asNameMap()[dataSource];
    if (mode == null) {
      throw ArgumentError.value(
        dataSource,
        'DATA_SOURCE',
        'Origen desconocido',
      );
    }

    Uri? baseUrl;
    if (apiBaseUrl.isNotEmpty) {
      baseUrl = Uri.tryParse(apiBaseUrl);
      if (baseUrl == null || !baseUrl.hasScheme || baseUrl.host.isEmpty) {
        throw ArgumentError.value(apiBaseUrl, 'API_BASE_URL', 'URL inválida');
      }
    }
    if (mode == DataSourceMode.remote && baseUrl == null) {
      throw ArgumentError('DATA_SOURCE=remote requiere API_BASE_URL.');
    }

    return AppConfig(environment: env, dataSource: mode, apiBaseUrl: baseUrl);
  }

  final Environment environment;
  final DataSourceMode dataSource;
  final Uri? apiBaseUrl;

  bool get usesMocks => dataSource == DataSourceMode.mock;

  @override
  List<Object?> get props => [environment, dataSource, apiBaseUrl];
}

final appConfigProvider = Provider<AppConfig>(
  (ref) => AppConfig.fromEnvironment(),
);
