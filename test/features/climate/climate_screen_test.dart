import 'package:flutter_test/flutter_test.dart';
import 'package:siembra_segura/core/l10n/app_localizations_es.dart';
import 'package:siembra_segura/features/climate/presentation/providers/climate_providers.dart';

import '../../helpers/failing_repositories.dart';
import '../../helpers/pump_app.dart';

void main() {
  final l10n = AppLocalizationsEs();

  Future<void> openClimate(WidgetTester tester) =>
      tester.tapText(l10n.actionSeePlan);

  testWidgets('muestra el clima de hoy y la semana', (tester) async {
    await tester.pumpSiembraSeguraApp();
    await openClimate(tester);

    expect(find.text('Hoy, domingo'), findsOneWidget);
    expect(find.text('Lluvia moderada'), findsOneWidget);
    expect(find.text('70% de probabilidad · 12 mm · 31 °C'), findsOneWidget);
    for (final day in ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb']) {
      expect(find.text(day), findsOneWidget, reason: day);
    }
    expect(find.text('40 mm'), findsOneWidget);
    expect(
      find.text('El miércoles se espera lluvia fuerte.', findRichText: true),
      findsOneWidget,
    );
    expect(
      find.textContaining(
        'no siembres ni abones hasta el jueves',
        findRichText: true,
      ),
      findsOneWidget,
    );
  });

  testWidgets('compara con un año normal', (tester) async {
    await tester.pumpSiembraSeguraApp();
    await openClimate(tester);
    // Está a un toque: "Ver más del clima".
    await tester.tapText(l10n.climateMore);

    expect(find.text('3 veces más'), findsOneWidget);
    expect(find.text('2 °C más'), findsOneWidget);
    expect(find.text('Muy húmedo'), findsOneWidget);
    expect(find.textContaining('Cifras de ejemplo.'), findsOneWidget);
  });

  testWidgets('el aviso de planificación lleva a Qué sembrar', (tester) async {
    await tester.pumpSiembraSeguraApp();
    await openClimate(tester);
    await tester.tapText(l10n.climateMore);

    await tester.tapText(l10n.climatePlanTitle);

    expect(find.text(l10n.recommendationTitle), findsOneWidget);
  });

  testWidgets('muestra un error con opción de reintentar', (tester) async {
    await tester.pumpSiembraSeguraApp(
      overrides: [
        climateRepositoryProvider.overrideWithValue(FailingClimateRepository()),
      ],
    );
    await openClimate(tester);

    expect(find.text(l10n.errorServer), findsOneWidget);
    expect(find.text(l10n.actionRetry), findsOneWidget);
  });
}
