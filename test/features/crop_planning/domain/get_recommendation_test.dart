import 'package:flutter_test/flutter_test.dart';
import 'package:siembra_segura/features/crop_planning/domain/crop_planning_models.dart';
import 'package:siembra_segura/features/crop_planning/domain/recommendation.dart';
import 'package:siembra_segura/shared/data/mock_catalog.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';
import 'package:siembra_segura/shared/domain/campaign_context.dart';

import '../../../helpers/planning_fixtures.dart';

void main() {
  const getRecommendation = referenceGetRecommendation;
  late CropPlanningData data;

  setUpAll(() async => data = await referencePlanningData());

  Recommendation recommend([
    CampaignContext context = const CampaignContext(),
  ]) => getRecommendation(
    data: data,
    catalog: referenceCatalog,
    context: context,
  );

  test('sin elecciones usa el escenario normal y la prioridad sugerida', () {
    final recommendation = recommend();

    expect(recommendation.scenario, ClimateScenario.normal);
    expect(recommendation.priority, referenceCatalog.defaultPriority);
    expect(recommendation.best.id, 'r3');
    expect(recommendation.bestResult.climateRisk, ClimateRisk.low);
    expect(recommendation.riskMonths, isEmpty);
  });

  test('respeta el escenario y la prioridad elegidos', () {
    final recommendation = recommend(
      CampaignContext(
        priorityId: MockCatalog.restoreSoil.id,
        selectedScenario: ClimateScenario.heavyRains,
      ),
    );

    expect(recommendation.scenario, ClimateScenario.heavyRains);
    expect(recommendation.priority, MockCatalog.restoreSoil);
    expect(recommendation.best.id, 'r1');
    expect(recommendation.bestResult.climateRisk, ClimateRisk.high);
    expect(recommendation.riskMonths, hasLength(2));
  });

  test('una prioridad guardada que ya no existe vuelve a la sugerida', () {
    expect(
      recommend(const CampaignContext(priorityId: 'retirada')).priority,
      referenceCatalog.defaultPriority,
    );
  });

  test('con orden del servidor se respeta ese orden', () {
    final fromServer = CropPlanningData(
      options: data.options,
      currentPractice: data.currentPractice,
      soilHealth: data.soilHealth,
      scenarioNotes: data.scenarioNotes,
      riskMonths: data.riskMonths,
      irrigationSource: data.irrigationSource,
      areaHectares: data.areaHectares,
      ranking: {
        MockCatalog.saveWater.id: {
          for (final scenario in ClimateScenario.values)
            scenario: ['r2', 'r1', 'r3'],
        },
      },
    );

    final recommendation = getRecommendation(
      data: fromServer,
      catalog: referenceCatalog,
      context: CampaignContext(priorityId: MockCatalog.saveWater.id),
    );

    expect(recommendation.rankedOptions.ids, ['r2', 'r1', 'r3']);
  });
}
