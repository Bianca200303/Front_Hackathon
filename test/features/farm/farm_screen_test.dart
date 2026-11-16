import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siembra_segura/core/l10n/app_localizations_es.dart';
import 'package:siembra_segura/shared/data/app_mode_stores.dart';
import 'package:siembra_segura/shared/data/in_memory_campaign_preferences_store.dart';
import 'package:siembra_segura/shared/data/mock_catalog.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';
import 'package:siembra_segura/shared/domain/app_mode.dart';
import 'package:siembra_segura/shared/domain/campaign_context.dart';
import 'package:siembra_segura/shared/state/campaign_context_provider.dart';
import 'package:siembra_segura/shared/state/farm_location_provider.dart';
import 'package:siembra_segura/shared/widgets/screen_layout.dart';

import '../../helpers/pump_app.dart';

void main() {
  final l10n = AppLocalizationsEs();

  testWidgets('muestra la parcela y el último cultivo anotado', (tester) async {
    await tester.pumpSiembraSeguraApp();

    expect(find.text('Hola, Doña Rosa'), findsOneWidget);
    expect(find.text('Valle del Chira'), findsOneWidget);
    expect(find.text('Poechos'), findsOneWidget);
    // La sugerencia se marca como tal.
    expect(find.text(l10n.farmSatelliteBadge), findsOneWidget);
    expect(
      find.textContaining('Tenemos anotado Arroz', findRichText: true),
      findsOneWidget,
    );
  });

  testWidgets('muestra las opciones que entrega el catálogo', (tester) async {
    await tester.pumpSiembraSeguraApp();

    // La pantalla es una lista: se desplaza hasta cada opción antes de
    // buscarla, en vez de suponer que todo cabe sin mover.
    Future<void> expectShown(String text) async {
      await tester.scrollIntoView(find.text(text));
      expect(find.text(text), findsOneWidget);
    }

    for (final priority in MockCatalog.catalog.priorities) {
      await expectShown(priority.name);
    }
    for (final restriction in MockCatalog.catalog.restrictions) {
      await expectShown(restriction.name);
    }
    await expectShown(MockCatalog.soilTextureQuestion);
    for (final texture in MockCatalog.soilTextures) {
      await expectShown(texture.name);
    }
  });

  testWidgets('la tierra que reconoce el agricultor manda y se guarda', (
    tester,
  ) async {
    await tester.pumpSiembraSeguraApp();

    await tester.tapText(MockCatalog.soilTextures.first.name);

    expect(
      tester.container.read(campaignContextProvider).soilTexture,
      SoilTexture.sandy,
    );

    await tester.tapText(l10n.farmSoilTextureUnknown);

    expect(tester.container.read(campaignContextProvider).soilTexture, isNull);
  });

  testWidgets('las elecciones actualizan el contexto de la campaña', (
    tester,
  ) async {
    await tester.pumpSiembraSeguraApp();

    await tester.tapText(MockCatalog.maize.name);
    await tester.tapText(MockCatalog.saveWater.name);
    await tester.tapText(MockCatalog.lowWater.name);

    final context = tester.container.read(campaignContextProvider);
    expect(context.lastCropId, MockCatalog.maize.id);
    expect(context.priorityId, MockCatalog.saveWater.id);
    expect(context.restrictionIds, {MockCatalog.lowWater.id});

    await tester.tapText(MockCatalog.lowWater.name);
    expect(
      tester.container.read(campaignContextProvider).restrictionIds,
      isEmpty,
    );
  });

  group('lo que ingresa el agricultor', () {
    // `IconButton` envuelve su icono en un `Tooltip`: se busca el botón
    // que lo contiene.
    Finder stepButton(String tooltip) => find.ancestor(
      of: find.byTooltip(tooltip),
      matching: find.byType(IconButton),
    );

    testWidgets('arranca con los valores sugeridos', (tester) async {
      await tester.pumpSiembraSeguraApp();

      expect(find.text('1 ha'), findsOneWidget);
      expect(find.text('1 campaña'), findsOneWidget);
      // El reloj de prueba está fijo en el 8 de noviembre de 2026.
      expect(find.text('8 de noviembre'), findsOneWidget);
    });

    testWidgets('las hectáreas y las campañas se suman y se guardan', (
      tester,
    ) async {
      await tester.pumpSiembraSeguraApp();

      await tester.ensureVisible(stepButton(l10n.farmAreaIncrease));
      await tester.tap(stepButton(l10n.farmAreaIncrease));
      await tester.pumpAndSettle();
      await tester.ensureVisible(stepButton(l10n.farmCampaignsIncrease));
      await tester.tap(stepButton(l10n.farmCampaignsIncrease));
      await tester.pumpAndSettle();

      final context = tester.container.read(campaignContextProvider);
      expect(context.areaHectares, 1.5);
      expect(context.consecutiveCampaigns, 2);
      expect(find.text('1.5 ha'), findsOneWidget);
      expect(find.text('2 campañas'), findsOneWidget);
    });

    testWidgets('no se puede bajar del mínimo', (tester) async {
      await tester.pumpSiembraSeguraApp();
      await tester.ensureVisible(stepButton(l10n.farmCampaignsDecrease));

      expect(
        tester
            .widget<IconButton>(stepButton(l10n.farmCampaignsDecrease))
            .onPressed,
        isNull,
      );
    });

    testWidgets('marca la chacra tocando el mapa', (tester) async {
      await tester.pumpSiembraSeguraApp();

      expect(find.text('-4.8650, -80.7200'), findsOneWidget);

      final map = find.ancestor(
        of: find.text(l10n.farmSatelliteCaption),
        matching: find.byType(AspectRatio),
      );
      await tester.ensureVisible(map);
      final box = tester.getRect(map);
      await tester.tapAt(box.topLeft + const Offset(1, 1));
      await tester.pumpAndSettle();

      final location = tester.container.read(farmLocationProvider);
      expect(location.latitude, closeTo(-4.70, 0.02));
      expect(location.longitude, closeTo(-81.10, 0.02));
      expect(find.text('-4.8650, -80.7200'), findsNothing);
    });

    testWidgets('la fecha de siembra abre el calendario de Flutter', (
      tester,
    ) async {
      await tester.pumpSiembraSeguraApp();

      await tester.tapText('8 de noviembre');

      expect(find.byType(DatePickerDialog), findsOneWidget);
    });

    testWidgets('la fecha elegida se muestra y se guarda', (tester) async {
      await tester.pumpSiembraSeguraApp();

      tester.container
          .read(campaignContextProvider.notifier)
          .selectPlantingDate(DateTime(2026, 12, 15));
      await tester.pumpAndSettle();

      expect(find.text('15 de diciembre'), findsOneWidget);
      expect(
        tester.container.read(campaignContextProvider).plantingDate,
        DateTime(2026, 12, 15),
      );
    });
  });

  testWidgets('"Escuchar" lee la pantalla con el cultivo elegido', (
    tester,
  ) async {
    final speech = await tester.pumpSiembraSeguraApp();

    await tester.tapText(MockCatalog.cotton.name);
    // El "Escuchar" de la cabecera (Semi tiene el suyo en su tarjeta).
    await tester.tap(
      find.descendant(
        of: find.byType(ScreenHeader),
        matching: find.byTooltip(l10n.actionListenSemantics),
      ),
    );
    await tester.pumpAndSettle();

    expect(speech.spoken.single, contains('Hola Doña Rosa'));
    expect(speech.spoken.single, contains('sembraste algodón'));
  });

  testWidgets('"Empezar" lleva a Clima', (tester) async {
    await tester.pumpSiembraSeguraApp();

    await tester.tapText(l10n.actionSeePlan);

    expect(find.text(l10n.climateTitle), findsOneWidget);
  });

  group('volver a los valores sugeridos', () {
    // `TextButton.icon` crea una subclase privada: se busca por predicado.
    Finder resetButton() => find.ancestor(
      of: find.text(l10n.farmResetAction),
      matching: find.byWidgetPredicate((widget) => widget is TextButton),
    );

    testWidgets('está deshabilitado si no hay nada elegido', (tester) async {
      await tester.pumpSiembraSeguraApp();
      await tester.ensureVisible(resetButton());

      expect(tester.widget<TextButton>(resetButton()).onPressed, isNull);
    });

    testWidgets('restablece y permite deshacer', (tester) async {
      await tester.pumpSiembraSeguraApp();
      await tester.tapText(MockCatalog.saveWater.name);

      await tester.tapText(l10n.farmResetAction);

      expect(
        tester.container.read(campaignContextProvider),
        const CampaignContext(),
      );
      expect(find.text(l10n.farmResetDone), findsOneWidget);

      await tester.tap(find.text(l10n.actionUndo));
      await tester.pumpAndSettle();

      expect(
        tester.container.read(campaignContextProvider).priorityId,
        MockCatalog.saveWater.id,
      );
    });
  });

  testWidgets('si ya configuró antes, arranca en Clima con lo guardado', (
    tester,
  ) async {
    await tester.pumpSiembraSeguraApp(
      preferencesStore: InMemoryCampaignPreferencesStore(
        CampaignContext(priorityId: MockCatalog.restoreSoil.id),
      ),
    );

    expect(find.text(l10n.climateTitle), findsOneWidget);
    expect(
      tester.container.read(campaignContextProvider).priorityId,
      MockCatalog.restoreSoil.id,
    );
  });

  testWidgets('se abre desde Ajustes en una pestaña y "Listo" vuelve a ella', (
    tester,
  ) async {
    await tester.pumpSiembraSeguraApp(
      // En modo asistido Ajustes abre la conversación (farm_chat_test).
      appModeStore: InMemoryAppModeStore(AppMode.manual),
    );
    await tester.tapText(l10n.actionSeePlan);
    await tester.tapTab(l10n.tabRotation);

    await tester.tap(find.byTooltip(l10n.settingsTooltip));
    await tester.pumpAndSettle();
    await tester.tapText(l10n.settingsEditFarm);

    expect(find.text(l10n.farmTitle), findsOneWidget);
    expect(find.byTooltip(l10n.actionBack), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);

    await tester.tapText(l10n.actionDone);

    expect(find.text(l10n.rotationTitle), findsOneWidget);
  });
}
