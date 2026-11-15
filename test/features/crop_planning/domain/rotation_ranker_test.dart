import 'package:flutter_test/flutter_test.dart';
import 'package:siembra_segura/features/crop_planning/domain/crop_planning_models.dart';
import 'package:siembra_segura/features/crop_planning/domain/rotation_ranker.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';

import '../../../helpers/planning_fixtures.dart';

/// Política de prueba: ordena por agua para cualquier prioridad salvo la
/// "desconocida", que no tiene criterio.
class _WaterPolicy implements RotationRankingPolicy {
  @override
  RotationComparator? comparatorFor(
    CampaignPriority priority,
    ClimateScenario scenario,
  ) => priority.id == 'unknown'
      ? null
      : (a, b) => a
            .resultFor(scenario)
            .waterUseM3
            .compareTo(b.resultFor(scenario).waterUseM3);
}

void main() {
  const anyPriority = CampaignPriority(id: 'p', name: 'P', phrase: 'p');
  const unknownPriority = CampaignPriority(
    id: 'unknown',
    name: 'Nueva',
    phrase: 'nueva',
  );
  final ranker = RotationRanker(_WaterPolicy());
  late List<RotationOption> options;

  setUpAll(() async => options = (await referencePlanningData()).options);

  List<String> rank({
    List<RotationOption>? from,
    CampaignPriority priority = anyPriority,
    Set<String> restrictionIds = const {},
    List<String> serverOrder = const [],
  }) => ranker
      .rank(
        options: from ?? options,
        scenario: ClimateScenario.heavyRains,
        priority: priority,
        restrictionIds: restrictionIds,
        serverOrder: serverOrder,
      )
      .ids;

  test('ordena con el criterio de la política', () {
    expect(rank(), ['r3', 'r1', 'r2']);
  });

  test('sin criterio para la prioridad conserva el orden de los datos', () {
    expect(rank(priority: unknownPriority), ['r1', 'r2', 'r3']);
  });

  test('el orden de la fuente manda sobre la política', () {
    expect(rank(serverOrder: ['r2', 'r3', 'r1']), ['r2', 'r3', 'r1']);
  });

  test('una opción que la fuente no menciona va al final', () {
    expect(rank(serverOrder: ['r2']), ['r2', 'r1', 'r3']);
  });

  test('descarta las opciones excluidas por una restricción activa', () {
    final excluder = options.firstWhere((o) => o.excludedBy.isNotEmpty);

    expect(
      rank(restrictionIds: {excluder.excludedBy.first}),
      isNot(contains(excluder.id)),
    );
    expect(rank(restrictionIds: {'restriccion-desconocida'}), hasLength(3));
  });

  test('los empates conservan el orden original', () {
    RotationOption copy(RotationOption source, String id) => RotationOption(
      id: id,
      crops: source.crops,
      scenarios: source.scenarios,
      soilImpact: source.soilImpact,
      soilInTwoYears: source.soilInTwoYears,
      factsheet: source.factsheet,
      schedule: source.schedule,
      longTermPlan: source.longTermPlan,
    );
    final tied = [
      for (final id in ['a', 'b', 'c', 'd']) copy(options.first, id),
    ];

    expect(rank(from: tied), ['a', 'b', 'c', 'd']);
  });

  test('devuelve una lista vacía si todo queda descartado', () {
    final excluder = options.firstWhere((o) => o.excludedBy.isNotEmpty);

    expect(
      rank(from: [excluder], restrictionIds: excluder.excludedBy),
      isEmpty,
    );
  });
}
