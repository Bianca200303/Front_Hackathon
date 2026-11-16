import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:siembra_segura/app/app.dart';
import 'package:siembra_segura/core/config/app_config.dart';
import 'package:siembra_segura/core/config/mock_latency.dart';
import 'package:siembra_segura/core/l10n/app_language.dart';
import 'package:siembra_segura/core/l10n/app_language_provider.dart';
import 'package:siembra_segura/core/services/location/device_location.dart';
import 'package:siembra_segura/core/services/speech/speech_service.dart';
import 'package:siembra_segura/core/theme/theme_mode_provider.dart';
import 'package:siembra_segura/core/utils/clock.dart';
import 'package:siembra_segura/shared/data/app_mode_stores.dart';
import 'package:siembra_segura/shared/data/in_memory_campaign_preferences_store.dart';
import 'package:siembra_segura/shared/domain/app_mode.dart';
import 'package:siembra_segura/shared/domain/campaign_preferences_store.dart';
import 'package:siembra_segura/shared/state/app_mode_provider.dart';
import 'package:siembra_segura/shared/state/campaign_context_provider.dart';

import 'fake_location_service.dart';
import 'fake_speech_service.dart';

const testConfig = AppConfig(
  environment: Environment.dev,
  dataSource: DataSourceMode.mock,
);

/// Domingo, como en la referencia: el miércoles es el día de lluvia fuerte
/// y el aviso de ejemplo del ENFEN llegó el viernes.
final testNow = DateTime(2026, 11, 8, 9);

Future<void> initTestLocale() => initializeDateFormatting();

/// Dependencias deterministas para cualquier `ProviderScope` de prueba.
List<Override> baseTestOverrides(
  FakeSpeechService speech, {
  CampaignPreferencesStore? preferencesStore,
  AppModeStore? appModeStore,
  AppLanguage? language = AppLanguage.spanish,
  AppLanguageStore? languageStore,
  ThemeModeStore? themeModeStore,
  AppConfig config = testConfig,
  DeviceLocationService? deviceLocation,
}) => [
  // Ningún test llama al GPS real.
  deviceLocationServiceProvider.overrideWithValue(
    deviceLocation ?? FakeLocationService(),
  ),
  // Por defecto la pantalla sigue al "celular" de la prueba (claro).
  themeModeStoreProvider.overrideWithValue(
    themeModeStore ?? InMemoryThemeModeStore(),
  ),
  // El idioma se fija (el del entorno de pruebas sería inglés); `null`
  // sigue a los idiomas del "celular" de la prueba.
  appLanguageStoreProvider.overrideWithValue(
    languageStore ?? InMemoryAppLanguageStore(language),
  ),
  // Por defecto el modo ya está elegido: la bienvenida de la primera vez
  // tiene su propia prueba.
  appModeStoreProvider.overrideWithValue(
    appModeStore ?? InMemoryAppModeStore(AppMode.assisted),
  ),
  campaignPreferencesStoreProvider.overrideWithValue(
    preferencesStore ?? InMemoryCampaignPreferencesStore(),
  ),
  appConfigProvider.overrideWithValue(config),
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
    AppModeStore? appModeStore,
    AppLanguage? language = AppLanguage.spanish,
    AppLanguageStore? languageStore,
    ThemeModeStore? themeModeStore,
    AppConfig config = testConfig,
    DeviceLocationService? deviceLocation,
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
          ...baseTestOverrides(
            speech,
            preferencesStore: preferencesStore,
            appModeStore: appModeStore,
            language: language,
            languageStore: languageStore,
            themeModeStore: themeModeStore,
            config: config,
            deviceLocation: deviceLocation,
          ),
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
    await tapVisible(finder);
  }

  /// Desplaza hasta [finder], lo toca y espera a que todo se asiente.
  Future<void> tapVisible(Finder finder) async {
    await scrollIntoView(finder);
    await tap(finder);
    await pumpAndSettle();
  }

  /// Desplaza hasta que [finder] quede en pantalla (aunque la lista aún no
  /// lo haya construido).
  Future<void> scrollIntoView(Finder finder) async {
    if (finder.evaluate().isEmpty) {
      await scrollUntilVisible(
        finder,
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
    await pumpAndSettle();
    // Con la guía de Semi arriba (NestedScrollView), `ensureVisible` no
    // siempre llega: se arrastra la lista hasta que se pueda tocar.
    final screen = Offset.zero & view.physicalSize / view.devicePixelRatio;
    for (var i = 0; i < 30 && !screen.contains(getCenter(finder)); i++) {
      await drag(
        find.ancestor(of: finder, matching: find.byType(Scrollable)).first,
        const Offset(0, -250),
      );
      await pumpAndSettle();
    }
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
