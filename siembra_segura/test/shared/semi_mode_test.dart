import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siembra_segura/core/l10n/app_localizations_es.dart';
import 'package:siembra_segura/shared/data/app_mode_stores.dart';
import 'package:siembra_segura/shared/domain/app_mode.dart';
import 'package:siembra_segura/shared/widgets/semi/semi_avatar.dart';
import 'package:siembra_segura/shared/widgets/semi/semi_painter.dart';

import '../helpers/pump_app.dart';

void main() {
  final l10n = AppLocalizationsEs();

  testWidgets('la primera vez se abre la bienvenida de Semi', (tester) async {
    final store = InMemoryAppModeStore();
    await tester.pumpSiembraSeguraApp(appModeStore: store);

    expect(find.text(l10n.welcomeTitle), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);

    await tester.tapText(l10n.welcomeManualTitle);

    expect(find.text(l10n.welcomeTitle), findsNothing);
    expect(find.text(l10n.farmTitle), findsOneWidget);
    // En llenado manual Semi no presenta la pantalla.
    expect(find.text(l10n.semiFarmGuide), findsNothing);
    expect(store.load(), AppMode.manual);
  });

  testWidgets('con un modo ya elegido no vuelve a preguntar', (tester) async {
    await tester.pumpSiembraSeguraApp();

    expect(find.text(l10n.welcomeTitle), findsNothing);
    expect(find.text(l10n.semiFarmGuide), findsOneWidget);
  });

  testWidgets('en llenado manual Semi espera a que le pregunten', (
    tester,
  ) async {
    final speech = await tester.pumpSiembraSeguraApp(
      appModeStore: InMemoryAppModeStore(AppMode.manual),
    );

    expect(find.text(l10n.semiFarmGuide), findsNothing);
    await tester.tapText(l10n.helpTitle);

    // Al pedirlo, aparece el globo y Semi lo lee en voz alta.
    expect(find.text(l10n.semiFarmGuide), findsOneWidget);
    expect(speech.spoken.last, l10n.semiFarmGuide);
  });

  testWidgets('el modo se cambia en Ajustes y se recuerda', (tester) async {
    final store = InMemoryAppModeStore(AppMode.assisted);
    await tester.pumpSiembraSeguraApp(appModeStore: store);
    await tester.tapText(l10n.actionSeePlan);
    await tester.tap(find.byTooltip(l10n.settingsTooltip));
    await tester.pumpAndSettle();

    await tester.tapText(l10n.appModeManualTitle);

    expect(store.load(), AppMode.manual);
  });

  testWidgets('en Asistencia Semi presenta la pantalla y se puede escuchar', (
    tester,
  ) async {
    final speech = await tester.pumpSiembraSeguraApp();

    final guideListen = find.descendant(
      of: find.ancestor(
        of: find.text(l10n.semiFarmGuide),
        matching: find.byType(Row),
      ),
      matching: find.byTooltip(l10n.actionListenSemantics),
    );
    await tester.tap(guideListen.first);
    await tester.pumpAndSettle();

    expect(speech.spoken.last, l10n.semiFarmGuide);
  });

  testWidgets('dibuja todas las expresiones de Semi', (tester) async {
    for (final expression in SemiExpression.values) {
      await tester.pumpWidget(
        MaterialApp(
          home: Row(
            children: [
              SemiAvatar(expression: expression),
              SemiAvatar.head(expression: expression),
            ],
          ),
        ),
      );
      // Deja correr el saludo y el parpadeo.
      await tester.pump(const Duration(seconds: 6));
      expect(tester.takeException(), isNull, reason: expression.name);
    }
  });
}
