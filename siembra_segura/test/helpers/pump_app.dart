import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:siembra_segura/app/app.dart';
import 'package:siembra_segura/core/config/app_config.dart';
import 'package:siembra_segura/core/config/mock_latency.dart';
import 'package:siembra_segura/core/services/speech/speech_service.dart';
import 'package:siembra_segura/core/utils/clock.dart';
import 'package:siembra_segura/shared/data/in_memory_campaign_preferences_store.dart';
import 'package:siembra_segura/shared/domain/campaign_preferences_store.dart';
import 'package:siembra_segura/shared/state/campaign_context_provider.dart';

import 'fake_speech_service.dart';

const testConfig = AppConfig(
  environment: Environment.dev,
  dataSource: DataSourceMode.mock,
);

/// Domingo, como en la referencia: el miércoles es el día de lluvia fuerte
/// y el aviso del ENFEN llegó el viernes.
final testNow = DateTime(2026, 11, 8, 9);

Future<void> initTestLocale() => initializeDateFormatting('es');

/// Dependencias deterministas para cualquier `ProviderScope` de prueba.
List<Override> baseTestOverrides(
  FakeSpeechService speech, {
  CampaignPreferencesStore? preferencesStore,
}) => [
  campaignPreferencesStoreProvider.overrideWithValue(
    preferencesStore ?? InMemoryCampaignPreferencesStore(),
  ),
  appConfigProvider.overrideWithValue(testConfig),
  speechServiceProvider.overrideWithValue(speech),
  mockLatencyProvider.overrideWithValue(Duration.zero),
  clockProvider.overrideWithValue(() => testNow),
];

extension PumpApp on WidgetTester {
  /// Monta la app completa con dependencias de prueba, en una pantalla de
  /// teléfono alta para que el contenido principal quepa sin desplazar.
  Future<FakeSpeechService> pumpSiembraSeguraApp({
    List<Override> overrides = const [],
    Size screenSize = const Size(430, 2400),
    CampaignPreferencesStore? preferencesStore,
  }) async {
    await initTestLocale();
    view
      ..physicalSize = screenSize * 3
      ..devicePixelRatio = 3;
    addTearDown(view.reset);

    final speech = FakeSpeechService();
    await pumpWidget(
      ProviderScope(
        retry: (_, _) => null,
        overrides: [
          ...baseTestOverrides(speech, preferencesStore: preferencesStore),
          ...overrides,
        ],
        child: const SiembraSeguraApp(),
      ),
    );
    await pumpAndSettle();
    return speech;
  }

  ProviderContainer get container =>
      ProviderScope.containerOf(element(find.byType(SiembraSeguraApp)));

  /// Toca un texto; si la lista aún no lo construyó, desplaza hasta él.
  Future<void> tapText(String text) async {
    final matches = find.text(text);
    final finder = matches.first;
    if (matches.evaluate().isEmpty) {
      await scrollUntilVisible(
        matches,
        300,
        scrollable: find
            .byWidgetPredicate(
              (widget) =>
                  widget is Scrollable &&
                  widget.axisDirection == AxisDirection.down,
            )
            .first,
      );
    }
    await ensureVisible(finder);
    await tap(finder);
    await pumpAndSettle();
  }

  Future<void> tapTab(String label) async {
    await tap(
      find.descendant(of: findNavigationBar(), matching: find.text(label)),
    );
    await pumpAndSettle();
  }
}

/// Barra inferior (teléfono) o riel lateral (tablet, horizontal).
Finder findNavigationBar() => find.byWidgetPredicate(
  (widget) => widget is NavigationBar || widget is NavigationRail,
);
