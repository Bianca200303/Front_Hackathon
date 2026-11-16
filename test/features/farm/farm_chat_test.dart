import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siembra_segura/core/l10n/app_localizations_es.dart';
import 'package:siembra_segura/core/services/location/device_location.dart';
import 'package:siembra_segura/features/farm/presentation/widgets/parcel_map_card.dart';
import 'package:siembra_segura/shared/data/app_mode_stores.dart';
import 'package:siembra_segura/shared/data/in_memory_campaign_preferences_store.dart';
import 'package:siembra_segura/shared/data/mock_catalog.dart';
import 'package:siembra_segura/shared/domain/app_mode.dart';
import 'package:siembra_segura/shared/state/farm_location_provider.dart';

import '../../helpers/fake_location_service.dart';
import '../../helpers/pump_app.dart';

void main() {
  final l10n = AppLocalizationsEs();

  Future<void> startChat(WidgetTester tester, {Size? size}) async {
    await tester.pumpSiembraSeguraApp(
      appModeStore: InMemoryAppModeStore(),
      screenSize: size ?? const Size(430, 2400),
    );
    await tester.tapText(l10n.welcomeAssistedTitle);
  }

  testWidgets('Semi pregunta una cosa a la vez y guarda las respuestas', (
    tester,
  ) async {
    final store = InMemoryCampaignPreferencesStore();
    await tester.pumpSiembraSeguraApp(
      appModeStore: InMemoryAppModeStore(),
      preferencesStore: store,
    );
    await tester.tapText(l10n.welcomeAssistedTitle);

    expect(find.text(l10n.chatTitle), findsOneWidget);
    expect(find.text(l10n.chatMapQuestion('Valle del Chira')), findsOne);
    await tester.tapText(l10n.chatMapConfirm);

    expect(find.text(l10n.chatLastCropQuestion('arroz')), findsOneWidget);
    // Lo del satélite primero; se puede corregir.
    expect(find.text(l10n.chatLastCropYes('arroz')), findsOneWidget);
    await tester.tapText(l10n.chatLastCropNo('maíz'));
    // Lo que respondió queda a la vista.
    expect(find.text(l10n.chatLastCropNo('maíz')), findsOneWidget);

    await tester.tapText(MockCatalog.saveWater.name);

    // Tres preguntas: chacra, último cultivo y prioridad. Las restricciones
    // se cambian en Mi parcela.
    expect(find.text(l10n.chatDone), findsOneWidget);
    expect(store.load()?.lastCropId, MockCatalog.maize.id);
    expect(store.load()?.priorityId, MockCatalog.saveWater.id);

    await tester.tapText(l10n.actionSeePlan);
    expect(find.text(l10n.climateTitle), findsOneWidget);
  });

  testWidgets('tocar el mapa marca la chacra', (tester) async {
    await startChat(tester);

    final map = find.byType(ValleyMapPicker);
    await tester.tapAt(tester.getRect(map).topLeft + const Offset(2, 2));
    await tester.pumpAndSettle();

    final location = tester.container.read(farmLocationProvider);
    expect(location.latitude, closeTo(ValleyMapPicker.bounds.north, 0.02));
    expect(location.longitude, closeTo(ValleyMapPicker.bounds.west, 0.02));

    await tester.tapText(l10n.chatMapConfirm);
    expect(find.textContaining(l10n.chatLastCropQuestion('arroz')), findsOne);
  });

  testWidgets('"Estoy en mi chacra" usa el GPS si cae en el valle', (
    tester,
  ) async {
    final gps = FakeLocationService(
      const LocationFound(latitude: -4.9, longitude: -80.9),
    );
    await tester.pumpSiembraSeguraApp(
      appModeStore: InMemoryAppModeStore(),
      deviceLocation: gps,
    );
    await tester.tapText(l10n.welcomeAssistedTitle);

    await tester.tapText(l10n.chatUseMyLocation);

    expect(gps.requests, 1);
    final location = tester.container.read(farmLocationProvider);
    expect((location.latitude, location.longitude), (-4.9, -80.9));
    // No avanza solo: muestra el punto y espera "Es aquí".
    expect(find.text(l10n.chatLocationFound), findsOneWidget);
    await tester.tapText(l10n.chatMapConfirm);
    expect(find.textContaining(l10n.chatLastCropQuestion('arroz')), findsOne);
  });

  for (final (name, result, message) in [
    (
      'fuera del valle',
      const LocationFound(latitude: -12.05, longitude: -77.04),
      AppLocalizationsEs().chatLocationOutside,
    ),
    (
      'sin permiso',
      const LocationDenied(),
      AppLocalizationsEs().chatLocationDenied,
    ),
    (
      'sin GPS',
      const LocationUnavailable(),
      AppLocalizationsEs().chatLocationUnavailable,
    ),
  ]) {
    testWidgets('$name: pide tocar el mapa y no mueve la chacra', (
      tester,
    ) async {
      await tester.pumpSiembraSeguraApp(
        appModeStore: InMemoryAppModeStore(),
        deviceLocation: FakeLocationService(result),
      );
      await tester.tapText(l10n.welcomeAssistedTitle);
      final before = tester.container.read(farmLocationProvider);

      await tester.tapText(l10n.chatUseMyLocation);

      expect(find.text(message), findsOneWidget);
      expect(tester.container.read(farmLocationProvider), before);
    });
  }

  testWidgets('Semi piensa un momento antes de hablar', (tester) async {
    await tester.pumpSiembraSeguraApp(appModeStore: InMemoryAppModeStore());
    await tester.tap(find.text(l10n.welcomeAssistedTitle));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.bySemanticsLabel(l10n.chatThinkingSemantics), findsOneWidget);
    expect(find.text(l10n.chatMapConfirm), findsNothing);

    await tester.pumpAndSettle();
    expect(find.text(l10n.chatMapConfirm), findsOneWidget);
  });

  testWidgets('"Escuchar" lee la pregunta y por qué la hace', (tester) async {
    final speech = await tester.pumpSiembraSeguraApp(
      appModeStore: InMemoryAppModeStore(),
    );
    await tester.tapText(l10n.welcomeAssistedTitle);
    await tester.tapText(l10n.chatMapConfirm);

    await tester.tapText(l10n.actionListen);

    expect(
      speech.spoken.last,
      '${l10n.chatLastCropQuestion('arroz')} ${l10n.chatLastCropWhy}',
    );
  });

  testWidgets('en modo asistido, Ajustes abre la conversación y vuelve', (
    tester,
  ) async {
    await tester.pumpSiembraSeguraApp(
      appModeStore: InMemoryAppModeStore(AppMode.assisted),
    );
    await tester.tapText(l10n.actionSeePlan);
    await tester.tapTab(l10n.tabRotation);
    await tester.tap(find.byTooltip(l10n.settingsTooltip));
    await tester.pumpAndSettle();
    await tester.tapText(l10n.settingsEditFarm);

    expect(find.text(l10n.chatTitle), findsOneWidget);
    await tester.tapText(l10n.chatMapConfirm);
    await tester.tapText(l10n.chatLastCropYes('arroz'));
    await tester.tapText(MockCatalog.lowerClimateRisk.name);
    await tester.tapText(l10n.actionSeePlan);

    expect(find.text(l10n.rotationTitle), findsOneWidget);
  });

  testWidgets('en modo manual, Ajustes abre el formulario', (tester) async {
    await tester.pumpSiembraSeguraApp(
      appModeStore: InMemoryAppModeStore(AppMode.manual),
    );
    await tester.tapText(l10n.actionSeePlan);
    await tester.tap(find.byTooltip(l10n.settingsTooltip));
    await tester.pumpAndSettle();
    await tester.tapText(l10n.settingsEditFarm);

    expect(find.text(l10n.farmTitle), findsOneWidget);
    expect(find.text(l10n.chatTitle), findsNothing);
  });

  testWidgets('como en el prototipo, el globo va arriba y Semi debajo', (
    tester,
  ) async {
    await startChat(tester, size: const Size(1280, 800));

    final semi = tester.getCenter(
      find.bySemanticsLabel(l10n.semiAvatarSemantics),
    );
    final question = tester.getCenter(
      find.text(l10n.chatMapQuestion('Valle del Chira')),
    );
    expect(question.dy, lessThan(semi.dy));
    expect(find.byType(NavigationRail), findsNothing);
  });
}
