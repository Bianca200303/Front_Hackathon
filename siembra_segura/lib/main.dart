import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:siembra_segura/app/app.dart';
import 'package:siembra_segura/core/config/app_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Falla al arrancar si la configuración del entorno es inválida.
  final config = AppConfig.fromEnvironment();

  runApp(
    ProviderScope(
      overrides: [appConfigProvider.overrideWithValue(config)],
      child: const SiembraSeguraApp(),
    ),
  );
}
