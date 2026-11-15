import 'package:flutter_test/flutter_test.dart';
import 'package:siembra_segura/core/l10n/app_localizations_es.dart';
import 'package:siembra_segura/features/crop_planning/data/mock_crop_planning_repository.dart';
import 'package:siembra_segura/features/crop_planning/domain/crop_planning_models.dart';
import 'package:siembra_segura/features/crop_planning/presentation/providers/crop_planning_providers.dart';
import 'package:siembra_segura/features/crop_planning/presentation/widgets/plan_blocks.dart';
import 'package:siembra_segura/shared/data/mock_catalog.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';
import 'package:siembra_segura/shared/state/campaign_context_provider.dart';

import '../../helpers/failing_repositories.dart';
import '../../helpers/planning_fixtures.dart';
import '../../helpers/pump_app.dart';

void main() {
  final l10n = AppLocalizationsEs();

  // Se carga fuera de testWidgets: allí el tiempo es simulado y los
  // Future.delayed de los mocks no avanzan solos.
  late CropPlanningData reference;
  setUpAll(() async => reference = await referencePlanningData());

  Future<void> openTab(WidgetTester tester, String tab) async {
    await tester.tapText(l10n.actionSeePlan);
    await tester.tapTab(tab);
  }

  group('Qué sembrar', () {
    testWidgets('recomienda como en el prototipo, sin dinero', (tester) async {
      await tester.pumpSiembraSeguraApp();
      await openTab(tester, l10n.tabWhatToPlant);

      expect(find.text(l10n.recoOverline), findsOneWidget);
      expect(find.text('Maíz y después frejol'), findsOneWidget);
      // Tres indicadores: cosecha, agua y tierra (datos NASA).
      expect(find.text('85%'), findsOneWidget);
      expect(find.text(l10n.waterLess('46%')), findsOneWidget);
      expect(find.text(l10n.soilGood), findsOneWidget);
      expect(find.text('15 de diciembre'), findsOneWidget);
      expect(find.text(l10n.whyTitle), findsOneWidget);
      expect(find.textContaining('S/'), findsNothing);
    });

    testWidgets('cambia al instante con la prioridad', (tester) async {
      await tester.pumpSiembraSeguraApp();
      await openTab(tester, l10n.tabWhatToPlant);

      tester.container
          .read(campaignContextProvider.notifier)
          .selectPriority(MockCatalog.saveWater.id);
      await tester.pumpAndSettle();

      expect(find.text('Frejol y después maíz'), findsOneWidget);
      expect(find.textContaining('cuidar tu agua'), findsWidgets);
    });
    testWidgets('las restricciones descartan opciones', (tester) async {
      await tester.pumpSiembraSeguraApp();
      tester.container.read(campaignContextProvider.notifier)
        ..selectScenario(ClimateScenario.dry)
        ..toggleRestriction(MockCatalog.noCottonBuyer.id);
      await openTab(tester, l10n.tabWhatToPlant);

      expect(find.text('Maíz y después frejol'), findsOneWidget);
    });

    testWidgets('sin opciones posibles muestra un estado vacío', (
      tester,
    ) async {
      final onlyCotton = CropPlanningData(
        options: reference.options.where((o) => o.id == 'r2').toList(),
        currentPractice: reference.currentPractice,
        soilHealth: reference.soilHealth,
        scenarioNotes: reference.scenarioNotes,
        riskMonths: reference.riskMonths,
        irrigationSource: reference.irrigationSource,
      );
      await tester.pumpSiembraSeguraApp(
        overrides: [
          cropPlanningRepositoryProvider.overrideWithValue(
            FixedCropPlanningRepository(onlyCotton),
          ),
        ],
      );
      tester.container
          .read(campaignContextProvider.notifier)
          .toggleRestriction(MockCatalog.lowWater.id);
      await openTab(tester, l10n.tabWhatToPlant);

      expect(find.text(l10n.emptyRecommendation), findsOneWidget);
    });

    testWidgets('sin conexión muestra error y reintentar', (tester) async {
      await tester.pumpSiembraSeguraApp(
        overrides: [
          cropPlanningRepositoryProvider.overrideWithValue(
            FailingCropPlanningRepository(),
          ),
        ],
      );
      await openTab(tester, l10n.tabWhatToPlant);

      expect(find.text(l10n.errorNetwork), findsOneWidget);
      expect(find.text(l10n.actionRetry), findsOneWidget);
    });
  });

  group('¿Cuándo siembro?', () {
    testWidgets('muestra fecha, calendario y razones', (tester) async {
      await tester.pumpSiembraSeguraApp();
      await openTab(tester, l10n.tabWhatToPlant);
      await tester.tapText(l10n.scheduleDecideBefore);

      expect(find.text('15 de diciembre'), findsOneWidget);
      for (final month in [
        'Dic',
        'Ene',
        'Feb',
        'Mar',
        'Abr',
        'May',
        'Jun',
        'Jul',
      ]) {
        expect(find.text(month), findsOneWidget, reason: month);
      }
      expect(
        find.text(
          'Febrero y marzo: riesgo de lluvia fuerte. Ten la cosecha cerca o '
          'protegida.',
        ),
        findsOneWidget,
      );
      expect(
        find.text('Gastas menos agua de Poechos que con arroz.'),
        findsOneWidget,
      );
    });

    testWidgets('envía la respuesta y agradece', (tester) async {
      final repository = MockCropPlanningRepository();
      await tester.pumpSiembraSeguraApp(
        overrides: [
          cropPlanningRepositoryProvider.overrideWithValue(repository),
        ],
      );
      await openTab(tester, l10n.tabWhatToPlant);
      await tester.tapText(l10n.scheduleDecideBefore);

      await tester.tapText('Sembré maíz');

      expect(find.text(l10n.feedbackThanksTitle), findsOneWidget);
      expect(repository.submittedFeedback, [
        const PlantingFeedback(rotationId: 'r1', followedRecommendation: true),
      ]);
    });

    testWidgets('si el envío falla, permite volver a intentar', (tester) async {
      await tester.pumpSiembraSeguraApp(
        overrides: [
          cropPlanningRepositoryProvider.overrideWithValue(
            FixedCropPlanningRepository(reference, failOnSubmit: true),
          ),
        ],
      );
      await openTab(tester, l10n.tabWhatToPlant);
      await tester.tapText(l10n.scheduleDecideBefore);

      await tester.tapText(l10n.feedbackOther);

      expect(find.text(l10n.errorServer), findsOneWidget);
      expect(find.text(l10n.feedbackOther), findsOneWidget);
    });
  });

  group('Rotación', () {
    testWidgets('compara lo actual con dos opciones, como filas', (
      tester,
    ) async {
      await tester.pumpSiembraSeguraApp();
      await openTab(tester, l10n.tabRotation);

      expect(find.text(l10n.soilTodayOverline), findsOneWidget);
      expect(find.text(l10n.soilTired), findsOneWidget);
      expect(find.text(l10n.rotationCompareTitle(3)), findsOneWidget);
      expect(find.text(l10n.optionCurrentLabel), findsOneWidget);
      expect(find.text(l10n.optionRecommendedLabel), findsOneWidget);
      expect(find.text(l10n.optionOtherLabel), findsOneWidget);
      // Lo actual (arroz) con lluvias fuertes: 55 % de una buena campaña.
      expect(find.text('55%'), findsOneWidget);
      expect(find.text('14,500 m³'), findsOneWidget);
      // Cada fila con su franja de 4 siembras.
      expect(find.byType(CropStrip), findsNWidgets(3));
    });

    testWidgets('despliega "Ver por qué" de una opción', (tester) async {
      await tester.pumpSiembraSeguraApp();
      await openTab(tester, l10n.tabRotation);

      await tester.tapText(l10n.seeWhy);

      expect(find.text(l10n.fichaWhy), findsOneWidget);
      expect(find.text(l10n.fichaCheck), findsOneWidget);
    });
  });
}
