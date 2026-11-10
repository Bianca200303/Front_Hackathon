import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siembra_segura/app/app.dart';
import 'package:siembra_segura/core/config/app_config.dart';
import 'package:siembra_segura/core/services/speech/speech_service.dart';

import 'fake_speech_service.dart';

const testConfig = AppConfig(
  environment: Environment.dev,
  dataSource: DataSourceMode.mock,
);

extension PumpApp on WidgetTester {
  /// Monta la app completa con dependencias de prueba.
  Future<FakeSpeechService> pumpSiembraSeguraApp({
    List<Override> overrides = const [],
  }) async {
    final speech = FakeSpeechService();
    await pumpWidget(
      ProviderScope(
        overrides: [
          appConfigProvider.overrideWithValue(testConfig),
          speechServiceProvider.overrideWithValue(speech),
          ...overrides,
        ],
        child: const SiembraSeguraApp(),
      ),
    );
    await pumpAndSettle();
    return speech;
  }
}

Finder findNavigationBar() => find.byType(NavigationBar);
