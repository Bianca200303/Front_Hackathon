import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siembra_segura/core/l10n/app_localizations_es.dart';
import 'package:siembra_segura/shared/widgets/responsive_columns.dart';

import '../helpers/pump_app.dart';
import 'accessibility_test.dart' show visitScreens;

/// Tamaños de ventana representativos (dp lógicos).
const _phonePortrait = Size(390, 844);
const _phoneLandscape = Size(844, 390);
const _tabletPortrait = Size(800, 1280);
const _tabletLandscape = Size(1280, 800);

void main() {
  final l10n = AppLocalizationsEs();

  Future<void> openClimate(WidgetTester tester, Size size) async {
    await tester.pumpSiembraSeguraApp(screenSize: size);
    await tester.tapText(l10n.actionStart);
  }

  group('navegación adaptable', () {
    testWidgets('teléfono en vertical: barra inferior', (tester) async {
      await openClimate(tester, _phonePortrait);

      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(NavigationRail), findsNothing);
    });

    for (final (name, size) in [
      ('teléfono en horizontal', _phoneLandscape),
      ('tablet en vertical', _tabletPortrait),
      ('tablet en horizontal', _tabletLandscape),
    ]) {
      testWidgets('$name: riel lateral', (tester) async {
        await openClimate(tester, size);

        expect(find.byType(NavigationRail), findsOneWidget);
        expect(find.byType(NavigationBar), findsNothing);

        await tester.tapTab(l10n.tabRotation);
        expect(find.text(l10n.rotationTitle), findsOneWidget);
      });
    }
  });

  group('columnas', () {
    /// Lado izquierdo de cada hijo directo del primer [ResponsiveColumns].
    List<double> columnStarts(WidgetTester tester) {
      final group = find.byType(ResponsiveColumns).first;
      final children = tester.widget<ResponsiveColumns>(group).children;
      return [
        for (final child in children.take(2))
          tester.getTopLeft(find.byWidget(child)).dx,
      ];
    }

    testWidgets('en teléfono las tarjetas van una debajo de otra', (
      tester,
    ) async {
      await tester.pumpSiembraSeguraApp(screenSize: _phonePortrait);

      final starts = columnStarts(tester);
      expect(starts[0], starts[1]);
    });

    testWidgets('en tablet horizontal van lado a lado', (tester) async {
      await tester.pumpSiembraSeguraApp(screenSize: _tabletLandscape);

      final starts = columnStarts(tester);
      expect(starts[1], greaterThan(starts[0]));
    });
  });

  group('sin desbordes', () {
    for (final (name, size, textScale) in [
      ('teléfono en horizontal', _phoneLandscape, 1.0),
      ('teléfono en horizontal con texto grande', _phoneLandscape, 1.5),
      ('tablet en vertical', _tabletPortrait, 1.0),
      ('tablet en horizontal con texto al doble', _tabletLandscape, 2.0),
    ]) {
      testWidgets(name, (tester) async {
        tester.platformDispatcher.textScaleFactorTestValue = textScale;
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

        await tester.pumpSiembraSeguraApp(screenSize: size);

        // Un desborde de layout haría fallar el test con una excepción.
        await visitScreens(tester, (screen) async {
          expect(tester.takeException(), isNull, reason: screen);
        });
      });
    }
  });
}
