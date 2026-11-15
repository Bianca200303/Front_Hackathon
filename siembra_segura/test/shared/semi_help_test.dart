import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siembra_segura/core/l10n/app_language.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/l10n/app_localizations_es.dart';
import 'package:siembra_segura/core/theme/theme_mode_provider.dart';
import 'package:siembra_segura/shared/data/app_mode_stores.dart';
import 'package:siembra_segura/shared/domain/app_mode.dart';
import 'package:siembra_segura/shared/widgets/semi/semi_help.dart';

import '../helpers/pump_app.dart';

void main() {
  final l10n = AppLocalizationsEs();

  Future<void> openHelp(WidgetTester tester, {String? tab}) async {
    await tester.tapText(l10n.actionSeePlan);
    if (tab != null) await tester.tapTab(tab);
    await tester.tap(find.bySemanticsLabel(l10n.helpButtonSemantics));
    await tester.pumpAndSettle();
  }

  testWidgets('el botón Ayuda abre las preguntas de la pestaña', (
    tester,
  ) async {
    await tester.pumpSiembraSeguraApp();
    await openHelp(tester);

    expect(find.text(l10n.helpTitle), findsOneWidget);
    expect(find.text(l10n.helpIntro(l10n.helpTopicClimate)), findsOneWidget);
    expect(find.text(l10n.helpRainMmQ), findsOneWidget);
    // Las de otra pestaña no aparecen como botón.
    expect(find.text(l10n.helpGreenManureQ), findsNothing);

    await tester.tapText(l10n.helpRainMmQ);

    expect(find.text(l10n.helpRainMmA), findsOneWidget);
    expect(find.text(l10n.helpYouAsked(l10n.helpRainMmQ)), findsOneWidget);
  });

  testWidgets('en Rotación pregunta por la rotación', (tester) async {
    await tester.pumpSiembraSeguraApp();
    await openHelp(tester, tab: l10n.tabRotation);

    expect(find.text(l10n.helpIntro(l10n.helpTopicRotation)), findsOneWidget);
    expect(find.text(l10n.helpGreenManureQ), findsOneWidget);
  });

  testWidgets('entiende lo que se escribe, sin tildes ni mayúsculas', (
    tester,
  ) async {
    await tester.pumpSiembraSeguraApp();
    await openHelp(tester);

    await tester.enterText(find.byType(TextField), 'Qué es el ABONO verde');
    await tester.tapText(l10n.helpAsk);
    expect(find.text(l10n.helpGreenManureA), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'de que satelite sale');
    await tester.tapText(l10n.helpAsk);
    expect(find.text(l10n.helpSourceA), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'xyz');
    await tester.tapText(l10n.helpAsk);
    expect(find.text(l10n.helpUnknown), findsOneWidget);
  });

  testWidgets('Semi pone la pantalla oscura si se lo pides', (tester) async {
    final store = InMemoryThemeModeStore();
    await tester.pumpSiembraSeguraApp(themeModeStore: store);
    await openHelp(tester);

    await tester.tapText(l10n.helpToDarkQ);

    expect(find.text(l10n.helpToDarkA), findsOneWidget);
    expect(store.load(), ThemeMode.dark);
    // Ahora ofrece volver a la clara.
    expect(find.text(l10n.helpToLightQ), findsOneWidget);
  });

  testWidgets('Semi cambia el modo de uso', (tester) async {
    final store = InMemoryAppModeStore(AppMode.assisted);
    await tester.pumpSiembraSeguraApp(appModeStore: store);
    await openHelp(tester);

    await tester.tapText(l10n.helpToManualQ);

    expect(store.load(), AppMode.manual);
    expect(find.text(l10n.helpToManualA), findsOneWidget);
  });

  testWidgets('"Cambiar los datos" lleva a la chacra', (tester) async {
    await tester.pumpSiembraSeguraApp(
      appModeStore: InMemoryAppModeStore(AppMode.manual),
    );
    await openHelp(tester);

    await tester.tapText(l10n.helpFarmQ);
    await tester.tapText(l10n.actionChange);

    expect(find.text(l10n.farmTitle), findsOneWidget);
  });

  test('la búsqueda ignora tildes y mayúsculas', () {
    expect(normalizeForSearch('Satélite NIÑO Ñandú'), 'satelite nino nandu');
  });

  group('se ve bien en los 3 idiomas', () {
    for (final language in AppLanguage.values) {
      testWidgets('${language.code}: teléfono pequeño con texto al doble', (
        tester,
      ) async {
        tester.platformDispatcher.textScaleFactorTestValue = 2;
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        final texts = lookupAppLocalizations(language.locale);

        await tester.pumpSiembraSeguraApp(
          screenSize: const Size(320, 640),
          language: language,
        );
        await tester.tapText(texts.actionSeePlan);
        await tester.tap(find.bySemanticsLabel(texts.helpButtonSemantics));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text(texts.helpTitle), findsOneWidget);
      });
    }
  });
}
