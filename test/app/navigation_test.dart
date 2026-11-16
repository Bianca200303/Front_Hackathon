import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siembra_segura/core/l10n/app_localizations_es.dart';

import '../helpers/pump_app.dart';

void main() {
  final l10n = AppLocalizationsEs();

  testWidgets('arranca en Mi parcela, sin pestañas', (tester) async {
    await tester.pumpSiembraSeguraApp();

    expect(find.text(l10n.farmTitle), findsOneWidget);
    expect(findNavigationBar(), findsNothing);
  });

  testWidgets('Empezar lleva a Clima y muestra las pestañas', (tester) async {
    await tester.pumpSiembraSeguraApp();
    await tester.tapText(l10n.actionSeePlan);

    expect(find.text(l10n.climateTitle), findsOneWidget);
    expect(findNavigationBar(), findsOneWidget);
  });

  testWidgets('las pestañas cambian de sección', (tester) async {
    await tester.pumpSiembraSeguraApp();
    await tester.tapText(l10n.actionSeePlan);

    final tabs = [
      (l10n.tabWhatToPlant, l10n.recommendationTitle, 1),
      (l10n.tabRotation, l10n.rotationTitle, 2),
      (l10n.tabAlerts, l10n.alertsTitle, 3),
      (l10n.tabClimate, l10n.climateTitle, 0),
    ];
    for (final (tab, title, index) in tabs) {
      await tester.tapTab(tab);
      final navigationBar = tester.widget<NavigationBar>(findNavigationBar());
      expect(navigationBar.selectedIndex, index, reason: 'pestaña $tab');
      // El título puede coincidir con la etiqueta de la pestaña ("Avisos").
      expect(find.text(title), findsAtLeastNWidgets(1), reason: 'pestaña $tab');
    }
  });

  testWidgets('¿Cuándo siembro? oculta las pestañas y vuelve atrás', (
    tester,
  ) async {
    await tester.pumpSiembraSeguraApp();
    await tester.tapText(l10n.actionSeePlan);
    await tester.tapTab(l10n.tabWhatToPlant);

    await tester.tapText(l10n.scheduleDecideBefore);
    expect(find.text(l10n.scheduleYourCalendar), findsOneWidget);
    expect(findNavigationBar(), findsNothing);

    await tester.tap(find.byTooltip(l10n.actionBack));
    await tester.pumpAndSettle();
    expect(find.text(l10n.recommendationTitle), findsOneWidget);
    expect(findNavigationBar(), findsOneWidget);
  });

  testWidgets('cambiar de pantalla detiene la lectura en voz alta', (
    tester,
  ) async {
    final speech = await tester.pumpSiembraSeguraApp();
    final before = speech.stopCalls;

    await tester.tapText(l10n.actionSeePlan);

    expect(speech.stopCalls, greaterThan(before));
  });
}
