import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Entorno en el que corre la app.
enum Environment {
  /// Desarrollo local.
  dev,

  /// Pruebas internas.
  staging,

  /// Producción.
  prod,
}

/// Origen de los datos de los repositorios.
///
/// `mock` usa datos locales de ejemplo; `remote` usa el backend en las
/// pantallas que ya tienen contrato y datos de ejemplo en el resto (ver
/// docs/ARCHITECTURE.md, §4).
enum DataSourceMode {
  /// Datos de ejemplo en memoria (repositorios mock).
  mock,

  /// Backend real donde ya está integrado; datos de ejemplo en el resto.
  remote,
}

/// De dónde sale la voz de Semi.
enum VoiceSource {
  /// Motor de voz del celular (`flutter_tts`).
  device,

  /// Audio generado por el backend (`POST v1/speech`, decisión B8), con la
  /// voz del celular como respaldo si falla la red.
  backend,
}

/// Configuración de la app, inyectada en tiempo de compilación con
/// `--dart-define-from-file=config/<entorno>.json`.
class AppConfig extends Equatable {
  /// Crea la configuración. En la app se usa [AppConfig.fromEnvironment].
  const AppConfig({
    required this.environment,
    required this.dataSource,
    this.apiBaseUrl,
    this.voiceSource = VoiceSource.device,
  });

  /// Lee la configuración de `--dart-define-from-file` (ver `config/`).
  factory AppConfig.fromEnvironment() => AppConfig.parse(
    environment: const String.fromEnvironment('APP_ENV', defaultValue: 'dev'),
    dataSource: const String.fromEnvironment(
      'DATA_SOURCE',
      defaultValue: 'mock',
    ),
    apiBaseUrl: const String.fromEnvironment('API_BASE_URL'),
    voiceSource: const String.fromEnvironment(
      'VOICE_SOURCE',
      defaultValue: 'device',
    ),
  );

  /// Construye y valida la configuración a partir de valores en texto.
  ///
  /// Lanza [ArgumentError] si algún valor es inválido, para fallar al
  /// arrancar en lugar de hacerlo en mitad de una petición.
  factory AppConfig.parse({
    required String environment,
    required String dataSource,
    String apiBaseUrl = '',
    String voiceSource = 'device',
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
      if (!baseUrl.path.endsWith('/')) {
        baseUrl = baseUrl.replace(path: '${baseUrl.path}/');
      }
    }
    if (mode == DataSourceMode.remote && baseUrl == null) {
      throw ArgumentError('DATA_SOURCE=remote requiere API_BASE_URL.');
    }

    final voice = VoiceSource.values.asNameMap()[voiceSource];
    if (voice == null) {
      throw ArgumentError.value(voiceSource, 'VOICE_SOURCE', 'Voz desconocida');
    }
    if (voice == VoiceSource.backend && baseUrl == null) {
      throw ArgumentError('VOICE_SOURCE=backend requiere API_BASE_URL.');
    }

    return AppConfig(
      environment: env,
      dataSource: mode,
      apiBaseUrl: baseUrl,
      voiceSource: voice,
    );
  }

  /// Entorno de ejecución.
  final Environment environment;

  /// De dónde salen los datos.
  final DataSourceMode dataSource;

  /// URL base del backend, siempre terminada en `/`; nula mientras se usan
  /// mocks.
  final Uri? apiBaseUrl;

  /// De dónde sale la voz de Semi. Es independiente de [dataSource]: la voz
  /// del backend puede probarse aunque los datos sigan siendo de ejemplo.
  final VoiceSource voiceSource;

  /// `true` si la app muestra datos de ejemplo.
  bool get usesMocks => dataSource == DataSourceMode.mock;

  @override
  List<Object?> get props => [environment, dataSource, apiBaseUrl, voiceSource];
}

/// Configuración vigente. `main.dart` la inyecta con `overrideWithValue`.
final appConfigProvider = Provider<AppConfig>(
  (ref) => AppConfig.fromEnvironment(),
);
