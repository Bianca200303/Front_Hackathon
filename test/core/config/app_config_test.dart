import 'package:flutter_test/flutter_test.dart';
import 'package:siembra_segura/core/config/app_config.dart';

void main() {
  group('AppConfig.parse', () {
    test('acepta un entorno mock sin URL', () {
      final config = AppConfig.parse(environment: 'dev', dataSource: 'mock');

      expect(config.environment, Environment.dev);
      expect(config.usesMocks, isTrue);
      expect(config.apiBaseUrl, isNull);
    });

    test('acepta remote con URL válida', () {
      final config = AppConfig.parse(
        environment: 'prod',
        dataSource: 'remote',
        apiBaseUrl: 'https://api.example.com/v1/',
      );

      expect(config.dataSource, DataSourceMode.remote);
      expect(config.apiBaseUrl, Uri.parse('https://api.example.com/v1/'));
    });

    test('rechaza remote sin URL', () {
      expect(
        () => AppConfig.parse(environment: 'prod', dataSource: 'remote'),
        throwsArgumentError,
      );
    });

    test('rechaza valores desconocidos o URL inválida', () {
      expect(
        () => AppConfig.parse(environment: 'qa', dataSource: 'mock'),
        throwsArgumentError,
      );
      expect(
        () => AppConfig.parse(environment: 'dev', dataSource: 'cache'),
        throwsArgumentError,
      );
      expect(
        () => AppConfig.parse(
          environment: 'dev',
          dataSource: 'mock',
          apiBaseUrl: 'no-es-url',
        ),
        throwsArgumentError,
      );
    });
  });
}
