import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siembra_segura/core/l10n/app_localizations_es.dart';
import 'package:siembra_segura/core/theme/app_palette.dart';
import 'package:siembra_segura/core/theme/theme_mode_provider.dart';
import 'package:siembra_segura/shared/data/app_mode_stores.dart';

import '../helpers/pump_app.dart';
import 'accessibility_test.dart' show visitScreens;

void main() {
  final l10n = AppLocalizationsEs();

  Brightness brightnessOf(WidgetTester tester, Finder finder) =>
      Theme.of(tester.element(finder)).brightness;

  testWidgets('la bienvenida pone la pantalla oscura y se recuerda', (
    tester,
  ) async {
    final store = InMemoryThemeModeStore();
    await tester.pumpSiembraSeguraApp(
      appModeStore: InMemoryAppModeStore(),
      themeModeStore: store,
    );
    final title = find.text(l10n.welcomeTitle);
    expect(brightnessOf(tester, title), Brightness.light);

    await tester.tap(find.byTooltip(l10n.themeToDark));
    await tester.pumpAndSettle();

    expect(brightnessOf(tester, title), Brightness.dark);
    expect(store.load(), ThemeMode.dark);
    expect(find.byTooltip(l10n.themeToLight), findsOneWidget);
  });

  testWidgets('en Ajustes se elige claro, oscuro o automático', (tester) async {
    await tester.pumpSiembraSeguraApp();
    await tester.tapText(l10n.actionSeePlan);
    await tester.tap(find.byTooltip(l10n.settingsTooltip));
    await tester.pumpAndSettle();

    await tester.tapText(l10n.themeDark);

    final title = find.text(l10n.climateTitle);
    expect(brightnessOf(tester, title), Brightness.dark);
    expect(tester.element(title).colors.background, AppPalette.dark.background);
  });

  testWidgets('en automático sigue al celular', (tester) async {
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

    await tester.pumpSiembraSeguraApp();

    expect(brightnessOf(tester, find.text(l10n.farmTitle)), Brightness.dark);
  });

  testWidgets('en oscuro todas las pantallas tienen buen contraste', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpSiembraSeguraApp(
      themeModeStore: InMemoryThemeModeStore(ThemeMode.dark),
    );

    await visitScreens(tester, (screen) async {
      expect(tester.takeException(), isNull, reason: screen);
      await expectLater(
        tester,
        meetsGuideline(textContrastGuideline),
        reason: screen,
      );
    });
    semantics.dispose();
  });
}
