import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siembra_segura/core/l10n/app_localizations_es.dart';
import 'package:siembra_segura/shared/data/in_memory_campaign_preferences_store.dart';
import 'package:siembra_segura/shared/data/mock_catalog.dart';
import 'package:siembra_segura/shared/domain/campaign_context.dart';
import 'package:siembra_segura/shared/state/campaign_context_provider.dart';

import '../../helpers/pump_app.dart';

void main() {
  final l10n = AppLocalizationsEs();

  testWidgets('muestra la parcela y lo que infirió el satélite', (
    tester,
  ) async {
    await tester.pumpSiembraSeguraApp();

    expect(find.text('Hola, Doña Rosa'), findsOneWidget);
    expect(find.text('Medio Piura'), findsOneWidget);
    expect(find.text('3.2 ha'), findsOneWidget);
    expect(find.text('Poechos'), findsOneWidget);
    expect(
      find.textContaining(
        'Por el satélite creemos que fue Arroz',
        findRichText: true,
      ),
      findsOneWidget,
    );
  });

  testWidgets('muestra las opciones que entrega el catálogo', (tester) async {
    await tester.pumpSiembraSeguraApp();

    for (final priority in MockCatalog.catalog.priorities) {
      expect(find.text(priority.name), findsOneWidget);
    }
    for (final restriction in MockCatalog.catalog.restrictions) {
      expect(find.text(restriction.name), findsOneWidget);
    }
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

  testWidgets('"Escuchar" lee la pantalla con el cultivo elegido', (
    tester,
  ) async {
    final speech = await tester.pumpSiembraSeguraApp();

    await tester.tapText(MockCatalog.cotton.name);
    await tester.tapText(l10n.actionListen);

    expect(speech.spoken.single, contains('Hola Doña Rosa'));
    expect(speech.spoken.single, contains('sembraste algodón'));
  });

  testWidgets('"Empezar" lleva a Clima', (tester) async {
    await tester.pumpSiembraSeguraApp();

    await tester.tapText(l10n.actionStart);

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

  testWidgets('se abre desde una pestaña y "Listo" vuelve a ella', (
    tester,
  ) async {
    await tester.pumpSiembraSeguraApp();
    await tester.tapText(l10n.actionStart);
    await tester.tapTab(l10n.tabRotation);

    await tester.tap(find.byTooltip(l10n.farmSettingsTooltip));
    await tester.pumpAndSettle();

    expect(find.text(l10n.farmTitle), findsOneWidget);
    expect(find.byTooltip(l10n.actionBack), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);

    await tester.tapText(l10n.actionDone);

    expect(find.text(l10n.rotationTitle), findsOneWidget);
  });
}
