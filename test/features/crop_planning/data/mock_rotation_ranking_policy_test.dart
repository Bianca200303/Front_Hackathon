import 'package:flutter_test/flutter_test.dart';
import 'package:siembra_segura/features/crop_planning/data/mock_rotation_ranking_policy.dart';
import 'package:siembra_segura/features/crop_planning/domain/crop_planning_models.dart';
import 'package:siembra_segura/features/crop_planning/domain/rotation_ranker.dart';
import 'package:siembra_segura/shared/data/mock_catalog.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';

import '../../../helpers/planning_fixtures.dart';

/// Reglas de la referencia (mvp.html) aplicadas a sus datos.
void main() {
  const ranker = RotationRanker(MockRotationRankingPolicy());
  late List<RotationOption> options;

  setUpAll(() async => options = (await referencePlanningData()).options);

  List<String> rank({
    ClimateScenario scenario = ClimateScenario.heavyRains,
    CampaignPriority priority = MockCatalog.maximizeProfit,
    Set<String> restrictionIds = const {},
  }) => ranker
      .rank(
        options: options,
        scenario: scenario,
        priority: priority,
        restrictionIds: restrictionIds,
      )
      .ids;

  test('"ganar más" ordena por ganancia esperada del escenario', () {
    expect(rank(), ['r1', 'r2', 'r3']);
    expect(rank(scenario: ClimateScenario.normal), ['r2', 'r1', 'r3']);
    expect(rank(scenario: ClimateScenario.dry), ['r2', 'r1', 'r3']);
  });

  test('"cuidar mi agua" ordena por menor consumo', () {
    expect(rank(priority: MockCatalog.saveWater), ['r3', 'r1', 'r2']);
  });

  test('"recuperar mi tierra" prioriza la mejora y luego la menor pérdida', () {
    expect(rank(priority: MockCatalog.restoreSoil), ['r1', 'r3', 'r2']);
  });

  test('cada restricción de ejemplo descarta el algodón (r2)', () {
    for (final restriction in referenceCatalog.restrictions) {
      expect(rank(restrictionIds: {restriction.id}), [
        'r1',
        'r3',
      ], reason: restriction.name);
    }
  });

  test('una prioridad que no conoce no tiene criterio', () {
    const policy = MockRotationRankingPolicy();
    const newPriority = CampaignPriority(
      id: 'nueva',
      name: 'Nueva',
      phrase: 'nueva',
    );

    expect(policy.comparatorFor(newPriority, ClimateScenario.dry), isNull);
  });
}
