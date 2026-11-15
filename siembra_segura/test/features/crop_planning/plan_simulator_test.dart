import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siembra_segura/core/l10n/app_localizations_es.dart';
import 'package:siembra_segura/shared/data/in_memory_campaign_preferences_store.dart';
import 'package:siembra_segura/shared/data/mock_catalog.dart';
import 'package:siembra_segura/shared/domain/campaign_context.dart';

import '../../helpers/pump_app.dart';

void main() {
  final l10n = AppLocalizationsEs();

  Future<void> openRotation(WidgetTester tester) async {
    await tester.tapText(l10n.actionSeePlan);
    await tester.tapTab(l10n.tabRotation);
  }

  /// Casilla del simulador para la campaña [period] (su etiqueta accesible
  /// empieza con el resultado, si lo hay, y luego "periodo: cultivo").
  Finder slot(String period) =>
      find.bySemanticsLabel(RegExp('^(.*\\. )?${RegExp.escape(period)}: '));

  Finder inSheet(String text) =>
      find.descendant(of: find.byType(BottomSheet), matching: find.text(text));

  testWidgets('arma un plan y ve campaña por campaña cómo le iría', (
    tester,
  ) async {
    await tester.pumpSiembraSeguraApp();
    await openRotation(tester);

    expect(find.text(l10n.simTitle), findsOneWidget);
    expect(find.text(l10n.simReset), findsNothing);

    // Cambia la segunda campaña (Abr–Jul) a abono verde.
    await tester.tapVisible(slot('Abr–Jul'));
    expect(find.text(l10n.simPickTitle('Abr–Jul')), findsOneWidget);
    await tester.tap(inSheet(MockCatalog.greenManure.name));
    await tester.pumpAndSettle();
    expect(find.text(l10n.simReset), findsOneWidget);

    await tester.tapText(l10n.simRun);

    expect(find.text(l10n.simGreenManureStep), findsOneWidget);
    expect(find.textContaining('Cosecha '), findsWidgets);
    expect(find.text(l10n.optionMineLabel), findsOneWidget);
    // Sin dinero: solo cosecha, agua y tierra.
    expect(find.textContaining('S/'), findsNothing);

    // Volver al recomendado borra el resultado anterior.
    await tester.tapText(l10n.simReset);
    expect(find.text(l10n.optionMineLabel), findsNothing);
    expect(find.text(l10n.simReset), findsNothing);
  });

  testWidgets('muestra la cosecha de a poco al simular', (tester) async {
    await tester.pumpSiembraSeguraApp();
    await openRotation(tester);
    final run = find.text(l10n.simRun);
    await tester.scrollIntoView(run);
    await tester.tap(run);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // A mitad de camino aún no está el resumen.
    expect(find.text(l10n.optionMineLabel), findsNothing);
    await tester.pumpAndSettle();
    expect(find.text(l10n.optionMineLabel), findsOneWidget);
  });

  testWidgets('las restricciones bloquean cultivos y explican por qué', (
    tester,
  ) async {
    await tester.pumpSiembraSeguraApp(
      preferencesStore: InMemoryCampaignPreferencesStore(
        CampaignContext(restrictionIds: {MockCatalog.noCottonBuyer.id}),
      ),
    );
    // Con preferencias guardadas abre directo en las pestañas.
    await tester.tapTab(l10n.tabRotation);

    await tester.tapVisible(slot('Dic–Mar').first);

    expect(
      find.text(l10n.simCropUnavailable(MockCatalog.noCottonBuyer.name)),
      findsOneWidget,
    );
    // Tocar el bloqueado no hace nada.
    await tester.tap(inSheet(MockCatalog.cotton.name));
    await tester.pumpAndSettle();
    expect(find.byType(BottomSheet), findsOneWidget);
  });

  testWidgets('como en el prototipo: se toca un cultivo y luego la siembra', (
    tester,
  ) async {
    await tester.pumpSiembraSeguraApp();
    await openRotation(tester);

    final greenManure = find.text(MockCatalog.greenManure.name);
    await tester.tapVisible(greenManure.last);
    await tester.tapVisible(slot('Abr–Jul'));

    // Sin abrir la lista: la siembra ya tiene el cultivo elegido.
    expect(find.byType(BottomSheet), findsNothing);
    expect(find.bySemanticsLabel(RegExp('Abr–Jul: Abono verde')), findsOne);
  });
}
