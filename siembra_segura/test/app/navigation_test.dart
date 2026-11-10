import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siembra_segura/core/l10n/app_localizations_es.dart';

import '../helpers/pump_app.dart';

void main() {
  final l10n = AppLocalizationsEs();

  Future<void> tapTab(WidgetTester tester, String label) async {
    await tester.tap(
      find.descendant(of: findNavigationBar(), matching: find.text(label)),
    );
    await tester.pumpAndSettle();
  }

  Future<void> start(WidgetTester tester) async {
    await tester.tap(find.text(l10n.actionStart));
    await tester.pumpAndSettle();
  }

  testWidgets('arranca en Mi parcela, sin pestañas', (tester) async {
    await tester.pumpSiembraSeguraApp();

    expect(find.text(l10n.farmTitle), findsOneWidget);
    expect(findNavigationBar(), findsNothing);
  });

  testWidgets('Empezar lleva a Clima y muestra las pestañas', (tester) async {
    await tester.pumpSiembraSeguraApp();
    await start(tester);

    expect(find.text(l10n.climateTitle), findsOneWidget);
    expect(findNavigationBar(), findsOneWidget);
  });

  testWidgets('las pestañas cambian de sección', (tester) async {
    await tester.pumpSiembraSeguraApp();
    await start(tester);

    final tabs = [
      (l10n.tabWhatToPlant, l10n.recommendationTitle, 1),
      (l10n.tabRotation, l10n.rotationTitle, 2),
      (l10n.tabAlerts, l10n.alertsTitle, 3),
      (l10n.tabClimate, l10n.climateTitle, 0),
    ];
    for (final (tab, title, index) in tabs) {
      await tapTab(tester, tab);
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
    await start(tester);
    await tapTab(tester, l10n.tabWhatToPlant);

    await tester.tap(find.text(l10n.actionWhenToPlant));
    await tester.pumpAndSettle();
    expect(find.text(l10n.plantingScheduleTitle), findsOneWidget);
    expect(findNavigationBar(), findsNothing);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.text(l10n.recommendationTitle), findsOneWidget);
    expect(findNavigationBar(), findsOneWidget);
  });

  testWidgets('el mensaje de un aviso se abre sin pestañas', (tester) async {
    await tester.pumpSiembraSeguraApp();
    await start(tester);
    await tapTab(tester, l10n.tabAlerts);

    await tester.tap(find.text(l10n.alertMessageTitle));
    await tester.pumpAndSettle();

    expect(findNavigationBar(), findsNothing);
    expect(find.text(l10n.actionSeeMyRecommendation), findsOneWidget);
  });

  testWidgets('cambiar de pantalla detiene la lectura en voz alta', (
    tester,
  ) async {
    final speech = await tester.pumpSiembraSeguraApp();
    final before = speech.stopCalls;

    await start(tester);

    expect(speech.stopCalls, greaterThan(before));
  });
}
