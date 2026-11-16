import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:siembra_segura/app/router/app_router.dart';
import 'package:siembra_segura/core/l10n/app_localizations_es.dart';
import 'package:siembra_segura/core/router/app_routes.dart';
import 'package:siembra_segura/core/utils/formatters.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';
import 'package:siembra_segura/shared/state/campaign_context_provider.dart';

import '../../helpers/pump_app.dart';

void main() {
  final l10n = AppLocalizationsEs();
  const forecastChange = 'Ejemplo: cambió el pronóstico de El Niño';

  Future<void> openAlerts(WidgetTester tester) async {
    await tester.tapText(l10n.actionSeePlan);
    await tester.tapTab(l10n.tabAlerts);
  }

  testWidgets('lista los avisos con su fuente y hora', (tester) async {
    await tester.pumpSiembraSeguraApp();
    await openAlerts(tester);

    expect(find.text('Lluvia fuerte el miércoles'), findsOneWidget);
    expect(find.text('Tu suelo está muy húmedo'), findsOneWidget);
    expect(find.text(forecastChange), findsOneWidget);
    expect(
      find.text(
        'Hoy, 6:00 a.${AppFormatters.nonBreakingSpace}m. · Pronóstico del día',
      ),
      findsOneWidget,
    );
    expect(find.text('Ayer · Aviso de ejemplo'), findsOneWidget);
    expect(find.text('Viernes · Aviso de ejemplo'), findsOneWidget);
  });

  testWidgets('la pestaña indica que hay avisos nuevos', (tester) async {
    await tester.pumpSiembraSeguraApp();
    await tester.tapText(l10n.actionSeePlan);

    final badges = tester.widgetList<Badge>(
      find.descendant(of: findNavigationBar(), matching: find.byType(Badge)),
    );
    expect(badges.any((badge) => badge.isLabelVisible), isTrue);
  });

  testWidgets('abre el mensaje, lo reproduce y lleva a la recomendación', (
    tester,
  ) async {
    final speech = await tester.pumpSiembraSeguraApp();
    tester.container
        .read(campaignContextProvider.notifier)
        .selectScenario(ClimateScenario.dry);
    await openAlerts(tester);

    await tester.tapText(forecastChange);
    expect(find.text('AVISO DE EJEMPLO'), findsOneWidget);
    expect(find.text('0:42'), findsOneWidget);
    expect(
      find.text('Viernes, 7:00 a.${AppFormatters.nonBreakingSpace}m.'),
      findsOneWidget,
    );
    expect(findNavigationBar(), findsNothing);

    await tester.tap(find.byTooltip(l10n.messagePlayAudio));
    await tester.pumpAndSettle();
    expect(speech.spoken.last, contains('este es un ejemplo'));
    expect(speech.spoken.last, isNot(contains('**')));

    await tester.tapText(l10n.actionSeeMyRecommendation);
    // El aviso de ejemplo abre el escenario de lluvias fuertes.
    expect(find.text(l10n.recommendationIfHeavyRains), findsOneWidget);
    expect(
      tester.container.read(campaignContextProvider).selectedScenario,
      ClimateScenario.heavyRains,
    );
  });

  testWidgets('el chat está deshabilitado hasta que exista el asistente', (
    tester,
  ) async {
    await tester.pumpSiembraSeguraApp();
    await openAlerts(tester);
    await tester.tapText(forecastChange);

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.enabled, isFalse);
    expect(find.text(l10n.messageChatComingSoon), findsOneWidget);
  });

  testWidgets('un aviso inexistente muestra "no encontrado"', (tester) async {
    await tester.pumpSiembraSeguraApp();
    tester.container.read(appRouterProvider).go(AppRoutes.alertDetail('nada'));
    await tester.pumpAndSettle();

    expect(find.text(l10n.errorNotFound), findsOneWidget);
    expect(tester.container.read(appRouterProvider), isA<GoRouter>());
  });
}
