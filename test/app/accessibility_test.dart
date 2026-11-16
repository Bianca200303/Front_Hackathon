import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/l10n/app_localizations_es.dart';

import '../helpers/pump_app.dart';

/// Recorre las pantallas principales y la hoja de Ajustes con las mismas
/// acciones, usando los textos de [l10n] (por defecto, español).
Future<void> visitScreens(
  WidgetTester tester,
  Future<void> Function(String screen) check, {
  AppLocalizations? l10n,
}) async {
  final texts = l10n ?? AppLocalizationsEs();
  await check('Mi parcela');
  await tester.tapText(texts.actionSeePlan);
  await check('Clima');
  for (final tab in [
    texts.tabWhatToPlant,
    texts.tabRotation,
    texts.tabAlerts,
  ]) {
    await tester.tapTab(tab);
    await check(tab);
  }
  await tester.tap(find.byTooltip(texts.settingsTooltip));
  await tester.pumpAndSettle();
  await check(texts.settingsTitle);
  Navigator.of(tester.element(find.text(texts.settingsTitle))).pop();
  await tester.pumpAndSettle();
  await tester.tapTab(texts.tabWhatToPlant);
  await tester.tapText(texts.scheduleDecideBefore);
  // Comprueba que de verdad se abrió (no solo que no hubo errores).
  expect(find.byTooltip(texts.actionBack), findsOneWidget);
  await check(texts.plantingScheduleTitle);
}

void main() {
  testWidgets('cumple las guías de accesibilidad de Flutter', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpSiembraSeguraApp();

    await visitScreens(tester, (screen) async {
      await expectLater(
        tester,
        meetsGuideline(androidTapTargetGuideline),
        reason: screen,
      );
      await expectLater(
        tester,
        meetsGuideline(labeledTapTargetGuideline),
        reason: screen,
      );
      await expectLater(
        tester,
        meetsGuideline(textContrastGuideline),
        reason: screen,
      );
    });

    semantics.dispose();
  });

  testWidgets('se adapta a un teléfono pequeño con texto al doble', (
    tester,
  ) async {
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpSiembraSeguraApp(screenSize: const Size(360, 740));

    // Un desborde de layout haría fallar el test con una excepción.
    await visitScreens(tester, (screen) async {
      expect(tester.takeException(), isNull, reason: screen);
    });
  });
}
