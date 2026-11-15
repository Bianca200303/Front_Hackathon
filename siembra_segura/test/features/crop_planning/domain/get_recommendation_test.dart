import 'package:flutter_test/flutter_test.dart';
import 'package:siembra_segura/features/crop_planning/domain/crop_planning_models.dart';
import 'package:siembra_segura/shared/data/mock_catalog.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';
import 'package:siembra_segura/shared/domain/campaign_context.dart';
import 'package:siembra_segura/shared/domain/seasonal_outlook.dart';

import '../../../helpers/planning_fixtures.dart';

void main() {
  const getRecommendation = referenceGetRecommendation;
  late CropPlanningData data;
  late SeasonalOutlook outlook;

  setUpAll(() async {
    data = await referencePlanningData();
    outlook = await referenceOutlook();
  });

  test('sin elecciones usa el escenario más probable y la prioridad '
      'sugerida', () {
    final recommendation = getRecommendation(
      data: data,
      outlook: outlook,
      catalog: referenceCatalog,
      context: const CampaignContext(),
    );

    expect(recommendation.scenario, ClimateScenario.heavyRains);
    expect(recommendation.isMostLikelyScenario, isTrue);
    expect(recommendation.priority, referenceCatalog.defaultPriority);
    expect(recommendation.best.id, 'r1');
    expect(recommendation.bestOutcome.expectedHarvest, 0.85);
    expect(recommendation.riskMonths, hasLength(2));
  });

  test('respeta el escenario y la prioridad elegidos', () {
    final recommendation = getRecommendation(
      data: data,
      outlook: outlook,
      catalog: referenceCatalog,
      context: CampaignContext(
        priorityId: MockCatalog.saveWater.id,
        selectedScenario: ClimateScenario.dry,
      ),
    );

    expect(recommendation.scenario, ClimateScenario.dry);
    expect(recommendation.isMostLikelyScenario, isFalse);
    expect(recommendation.priority, MockCatalog.saveWater);
    expect(recommendation.best.id, 'r3');
    expect(recommendation.riskMonths, isEmpty);
  });

  test('una prioridad guardada que ya no existe vuelve a la sugerida', () {
    final recommendation = getRecommendation(
      data: data,
      outlook: outlook,
      catalog: referenceCatalog,
      context: const CampaignContext(priorityId: 'retirada'),
    );

    expect(recommendation.priority, referenceCatalog.defaultPriority);
  });
}
