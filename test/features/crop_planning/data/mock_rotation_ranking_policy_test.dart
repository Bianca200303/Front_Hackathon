import 'package:flutter_test/flutter_test.dart';
import 'package:siembra_segura/features/crop_planning/data/mock_rotation_ranking_policy.dart';
import 'package:siembra_segura/features/crop_planning/domain/crop_planning_models.dart';
import 'package:siembra_segura/features/crop_planning/domain/rotation_ranker.dart';
import 'package:siembra_segura/shared/data/mock_catalog.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';

import '../../../helpers/planning_fixtures.dart';

/// Criterios del servidor replicados sobre los datos de ejemplo.
void main() {
  const ranker = RotationRanker(MockRotationRankingPolicy());
  late List<RotationOption> options;

  setUpAll(() async => options = (await referencePlanningData()).options);

  List<String> rank({
    ClimateScenario scenario = ClimateScenario.normal,
    CampaignPriority priority = MockCatalog.lowerClimateRisk,
    Set<String> restrictionIds = const {},
  }) => ranker
      .rank(
        options: options,
        scenario: scenario,
        priority: priority,
        restrictionIds: restrictionIds,
      )
      .ids;

  test('"cuidar mi agua" ordena por menor consumo', () {
    expect(rank(priority: MockCatalog.saveWater), ['r3', 'r1', 'r2']);
    expect(
      rank(
        priority: MockCatalog.saveWater,
        scenario: ClimateScenario.heavyRains,
      ),
      ['r3', 'r1', 'r2'],
    );
  });

  test('"recuperar mi tierra" prioriza la mejora del suelo', () {
    expect(rank(priority: MockCatalog.restoreSoil), ['r1', 'r2', 'r3']);
  });

  test('"menos riesgo de clima" desempata por agua', () {
    expect(rank(), ['r3', 'r1', 'r2']);
  });

  test('cada restricción de ejemplo descarta el algodón (r2)', () {
    for (final restriction in referenceCatalog.restrictions) {
      expect(rank(restrictionIds: {restriction.id}), [
        'r3',
        'r1',
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
