import 'package:flutter_test/flutter_test.dart';
import 'package:siembra_segura/core/l10n/app_localizations_es.dart';
import 'package:siembra_segura/features/crop_planning/data/mock_crop_planning_repository.dart';
import 'package:siembra_segura/features/crop_planning/domain/crop_planning_models.dart';
import 'package:siembra_segura/features/crop_planning/presentation/providers/crop_planning_providers.dart';
import 'package:siembra_segura/shared/data/mock_catalog.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';
import 'package:siembra_segura/shared/state/campaign_context_provider.dart';
import 'package:siembra_segura/shared/widgets/selection_controls.dart';

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
    await tester.tapText(l10n.actionStart);
    await tester.tapTab(tab);
  }

  Finder richText(String text) => find.textContaining(text, findRichText: true);

  group('Qué sembrar', () {
    testWidgets('recomienda para el escenario normal', (tester) async {
      await tester.pumpSiembraSeguraApp();
      await openTab(tester, l10n.tabWhatToPlant);

      expect(find.text(l10n.recommendationHeadline), findsOneWidget);
      expect(find.text('Frejol y después maíz'), findsOneWidget);
      expect(richText('Agua de riego: 13,800 m³'), findsOneWidget);
      expect(richText('Riesgo de clima: bajo'), findsOneWidget);
      expect(find.text('SI SIEMBRAS ARROZ OTRA VEZ'), findsOneWidget);
    });

    testWidgets('cambia al instante con la prioridad', (tester) async {
      await tester.pumpSiembraSeguraApp();
      await openTab(tester, l10n.tabWhatToPlant);

      tester.container
          .read(campaignContextProvider.notifier)
          .selectPriority(MockCatalog.restoreSoil.id);
      await tester.pumpAndSettle();

      expect(find.text('Maíz y después frejol'), findsOneWidget);
      expect(richText('recuperar tu tierra'), findsOneWidget);
    });

    testWidgets('explora otros escenarios', (tester) async {
      await tester.pumpSiembraSeguraApp();
      await openTab(tester, l10n.tabWhatToPlant);

      await tester.tapText(l10n.recommendationExploreScenarios);
      final drySegment = find.descendant(
        of: find.byType(SegmentedSelector<ClimateScenario>),
        matching: find.text(l10n.scenarioDry),
      );
      await tester.ensureVisible(drySegment);
      await tester.tap(drySegment);
      await tester.pumpAndSettle();

      expect(find.text(l10n.recommendationIfDry), findsOneWidget);
      expect(find.text('Frejol y después maíz'), findsOneWidget);
      expect(richText('Agua de riego: 16,560 m³'), findsOneWidget);
    });

    testWidgets('muestra la lluvia que ya midió el satélite', (tester) async {
      await tester.pumpSiembraSeguraApp();
      await openTab(tester, l10n.tabWhatToPlant);

      await tester.tapText(l10n.recommendationExploreScenarios);

      expect(
        find.textContaining('medidos por el satélite GPM'),
        findsOneWidget,
      );
    });

    testWidgets('las restricciones descartan opciones', (tester) async {
      await tester.pumpSiembraSeguraApp();
      tester.container
          .read(campaignContextProvider.notifier)
          .toggleRestriction(MockCatalog.noCottonBuyer.id);
      await openTab(tester, l10n.tabRotation);

      expect(find.text('Algodón y después menestra'), findsNothing);
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
        areaHectares: reference.areaHectares,
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
      await tester.tapText(l10n.actionWhenToPlant);

      expect(find.text('15 de diciembre'), findsOneWidget);
      expect(find.text('Frejol y después maíz'), findsOneWidget);
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
        find.text('Gastas menos agua de Poechos que con arroz.'),
        findsOneWidget,
      );
    });

    testWidgets('con lluvias fuertes marca los meses de riesgo', (
      tester,
    ) async {
      await tester.pumpSiembraSeguraApp();
      tester.container
          .read(campaignContextProvider.notifier)
          .selectScenario(ClimateScenario.heavyRains);
      await openTab(tester, l10n.tabWhatToPlant);
      await tester.tapText(l10n.actionWhenToPlant);

      expect(
        find.text(
          'Febrero y marzo: riesgo de lluvia fuerte. Ten la cosecha cerca o '
          'protegida.',
        ),
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
      await tester.tapText(l10n.actionWhenToPlant);

      await tester.tapText('Sembré frejol');

      expect(find.text(l10n.feedbackThanksTitle), findsOneWidget);
      expect(repository.submittedFeedback, [
        const PlantingFeedback(rotationId: 'r3', followedRecommendation: true),
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
      await tester.tapText(l10n.actionWhenToPlant);

      await tester.tapText(l10n.feedbackOther);

      expect(find.text(l10n.errorServer), findsOneWidget);
      expect(find.text(l10n.feedbackOther), findsOneWidget);
    });
  });

  group('Rotación', () {
    testWidgets('compara lo actual con dos opciones', (tester) async {
      await tester.pumpSiembraSeguraApp();
      await openTab(tester, l10n.tabRotation);

      expect(find.text(l10n.soilTired), findsOneWidget);
      expect(find.text(l10n.rotationCompareTitle(3)), findsOneWidget);
      expect(find.text(l10n.optionCurrent), findsOneWidget);
      expect(find.text(l10n.optionRecommended), findsOneWidget);
      expect(find.text(l10n.optionOther), findsOneWidget);
      expect(find.text('Arroz y arroz'), findsOneWidget);
      expect(find.text('29,000 m³'), findsOneWidget);
      expect(find.text('13,800 m³'), findsOneWidget);
      expect(find.text(l10n.climateRiskLow), findsWidgets);
    });

    testWidgets('muestra el plan de largo plazo', (tester) async {
      await tester.pumpSiembraSeguraApp();
      await openTab(tester, l10n.tabRotation);

      await tester.ensureVisible(find.text(l10n.rotationPlanTitle));
      expect(
        find.text('Frejol y después maíz y después menestra y algodón.'),
        findsOneWidget,
      );
      expect(find.text('Dic–Feb'), findsOneWidget);
      expect(find.text('Tierra: buena'), findsWidgets);
    });

    testWidgets('arma una rotación propia y ve cómo cambia', (tester) async {
      await tester.pumpSiembraSeguraApp();
      await openTab(tester, l10n.tabRotation);

      // La secuencia arranca con la recomendada: frejol y después maíz.
      await tester.tapText(l10n.rotationCustomTitle);
      await tester.tapText(MockCatalog.bean.name);
      // Cada cultivo del selector dice qué pide y qué deja.
      expect(find.text('Mucha agua · 5 meses'), findsOneWidget);
      expect(
        find.text('Poca agua · 4 meses · Abona tu tierra'),
        findsOneWidget,
      );
      await tester.tapText(MockCatalog.rice.name);

      expect(tester.container.read(campaignContextProvider).customRotation, [
        'rice',
        'maize',
      ]);
      expect(find.text(l10n.optionCustom), findsOneWidget);
      // Arroz 5 meses y maíz 4, con el agua de ejemplo de cada uno.
      expect(find.text('22,500 m³'), findsOneWidget);

      await tester.tapText(l10n.rotationCustomClear);

      expect(
        tester.container.read(campaignContextProvider).customRotation,
        isEmpty,
      );
      expect(find.text(l10n.optionCustom), findsNothing);
    });

    testWidgets('despliega la ficha de una opción', (tester) async {
      await tester.pumpSiembraSeguraApp();
      await openTab(tester, l10n.tabRotation);

      await tester.tapText(l10n.factsheetToggle);

      expect(find.text(l10n.factsheetWhy), findsOneWidget);
      expect(find.text(l10n.factsheetRisks), findsOneWidget);
    });
  });
}
