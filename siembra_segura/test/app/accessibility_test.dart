import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siembra_segura/core/l10n/app_localizations_es.dart';

import '../helpers/pump_app.dart';

/// Recorre las pantallas principales con las mismas acciones.
Future<void> visitScreens(
  WidgetTester tester,
  Future<void> Function(String screen) check,
) async {
  final l10n = AppLocalizationsEs();
  await check('Mi parcela');
  await tester.tapText(l10n.actionStart);
  await check('Clima');
  for (final tab in [l10n.tabWhatToPlant, l10n.tabRotation, l10n.tabAlerts]) {
    await tester.tapTab(tab);
    await check(tab);
  }
  await tester.tapTab(l10n.tabWhatToPlant);
  await tester.tapText(l10n.actionWhenToPlant);
  await check('¿Cuándo siembro?');
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
