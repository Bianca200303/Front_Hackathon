import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siembra_segura/core/l10n/app_language.dart';
import 'package:siembra_segura/core/l10n/app_language_provider.dart'
    show InMemoryAppLanguageStore;
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/l10n/app_localizations_en.dart';
import 'package:siembra_segura/core/l10n/app_localizations_es.dart';
import 'package:siembra_segura/core/l10n/app_localizations_qu.dart';
import 'package:siembra_segura/shared/data/app_mode_stores.dart';

import '../helpers/pump_app.dart';
import 'accessibility_test.dart' show visitScreens;

/// Textos de [language], para recorrer la app en ese idioma.
AppLocalizations textsOf(AppLanguage language) =>
    lookupAppLocalizations(language.locale);

void main() {
  final es = AppLocalizationsEs();
  final en = AppLocalizationsEn();
  final qu = AppLocalizationsQu();

  group('elegir idioma', () {
    testWidgets('en Ajustes se cambia a inglés y se recuerda', (tester) async {
      final store = InMemoryAppLanguageStore(AppLanguage.spanish);
      await tester.pumpSiembraSeguraApp(languageStore: store);
      await tester.tapText(es.actionSeePlan);

      await tester.tap(find.byTooltip(es.settingsTooltip));
      await tester.pumpAndSettle();
      await tester.tapText(en.languageEnglish);

      expect(find.text(en.settingsTitle), findsOneWidget);
      expect(store.load(), AppLanguage.english);
      Navigator.of(tester.element(find.text(en.settingsTitle))).pop();
      await tester.pumpAndSettle();
      expect(find.text(en.tabWhatToPlant), findsOneWidget);
      expect(find.text(en.climateTitle), findsOneWidget);
    });

    testWidgets('en automático sigue al celular y a su región', (tester) async {
      // Celular en francés, comprado en Perú.
      tester.platformDispatcher.localesTestValue = const [Locale('fr', 'PE')];
      addTearDown(tester.platformDispatcher.clearLocalesTestValue);

      await tester.pumpSiembraSeguraApp(language: null);

      expect(find.text(es.actionSeePlan), findsOneWidget);
    });

    testWidgets('en quechua lo que falta traducir se ve en español', (
      tester,
    ) async {
      await tester.pumpSiembraSeguraApp(language: AppLanguage.quechua);
      await tester.tapText(qu.actionSeePlan);

      expect(find.text(qu.tabWhatToPlant), findsOneWidget);
      expect(qu.tabWhatToPlant, isNot(es.tabWhatToPlant));
      // Sin traducción todavía: el texto en español.
      expect(qu.climatePlanAction, es.climatePlanAction);
    });

    testWidgets('la bienvenida permite elegir idioma desde el inicio', (
      tester,
    ) async {
      await tester.pumpSiembraSeguraApp(appModeStore: InMemoryAppModeStore());

      await tester.tap(find.text(es.languageButton(es.languageSpanish)));
      await tester.pumpAndSettle();
      await tester.tapText(es.languageQuechua);
      Navigator.of(tester.element(find.text(qu.settingsLanguageTitle))).pop();
      await tester.pumpAndSettle();

      expect(find.text(qu.welcomeTitle), findsOneWidget);
    });
  });

  group('sin desbordes en los 3 idiomas', () {
    const sizes = [
      ('teléfono pequeño', Size(320, 568), 1.0),
      ('teléfono con texto al doble', Size(390, 844), 2.0),
      ('teléfono en horizontal con texto grande', Size(844, 390), 1.3),
      ('tablet en horizontal con texto al doble', Size(1280, 800), 2.0),
    ];
    for (final language in AppLanguage.values) {
      for (final (name, size, textScale) in sizes) {
        testWidgets('${language.code}: $name', (tester) async {
          tester.platformDispatcher.textScaleFactorTestValue = textScale;
          addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

          await tester.pumpSiembraSeguraApp(
            screenSize: size,
            language: language,
          );

          // Un desborde de layout haría fallar el test con una excepción.
          await visitScreens(tester, (screen) async {
            expect(tester.takeException(), isNull, reason: screen);
          }, l10n: textsOf(language));
        });

        testWidgets('${language.code}: conversación con Semi, $name', (
          tester,
        ) async {
          tester.platformDispatcher.textScaleFactorTestValue = textScale;
          addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
          final texts = textsOf(language);

          await tester.pumpSiembraSeguraApp(
            screenSize: size,
            language: language,
            appModeStore: InMemoryAppModeStore(),
          );
          await tester.tapText(texts.welcomeAssistedTitle);
          // Confirma la chacra en el mapa y después responde siempre la
          // primera opción hasta el final.
          for (var step = 0; step < 5; step++) {
            expect(tester.takeException(), isNull, reason: 'paso $step');
            // Las respuestas, sin el botón "Escuchar" (también es outlined).
            final answers = find.byWidgetPredicate(
              (widget) =>
                  widget is OutlinedButton &&
                  find
                      .descendant(
                        of: find.byWidget(widget),
                        matching: find.text(texts.actionListen),
                      )
                      .evaluate()
                      .isEmpty,
            );
            final first = step == 0 ? find.text(texts.chatMapConfirm) : answers;
            if (first.evaluate().isEmpty) break;
            await tester.ensureVisible(first.first);
            await tester.tap(first.first);
            await tester.pumpAndSettle();
          }
          expect(find.text(texts.actionSeePlan), findsOneWidget);
          expect(tester.takeException(), isNull);
        });

        testWidgets('${language.code}: bienvenida, $name', (tester) async {
          tester.platformDispatcher.textScaleFactorTestValue = textScale;
          addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

          await tester.pumpSiembraSeguraApp(
            screenSize: size,
            language: language,
            appModeStore: InMemoryAppModeStore(),
          );

          expect(tester.takeException(), isNull);
          expect(find.text(textsOf(language).welcomeTitle), findsOneWidget);
        });
      }
    }
  });
}
