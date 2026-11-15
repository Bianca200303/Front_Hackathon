import 'package:siembra_segura/features/crop_planning/domain/crop_planning_models.dart';
import 'package:siembra_segura/features/crop_planning/domain/rotation_ranker.dart';
import 'package:siembra_segura/shared/data/mock_catalog.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';

/// Criterio de orden de ejemplo, asociado a las prioridades del catálogo de
/// ejemplo. Todo se decide con datos de clima, agua y tierra (NASA); nunca
/// con precios.
///
/// - "Que el clima no malogre mi cosecha": mayor cosecha esperada con el
///   clima del escenario y, a igualdad, la que mejor aguanta un mal año.
/// - "Cuidar mi agua": menor consumo de agua.
/// - "Recuperar mi tierra": mayor mejora del suelo y, a igualdad, la que
///   mejor aguanta un mal año.
///
/// Vive en la capa de datos porque depende de los identificadores del
/// catálogo de ejemplo. Una prioridad desconocida no tiene criterio.
class MockRotationRankingPolicy implements RotationRankingPolicy {
  /// Crea la política de ejemplo.
  const MockRotationRankingPolicy();

  @override
  RotationComparator? comparatorFor(
    CampaignPriority priority,
    ClimateScenario scenario,
  ) {
    if (priority.id == MockCatalog.protectHarvest.id) {
      return (a, b) => _compareHarvest(a, b, scenario);
    }
    if (priority.id == MockCatalog.saveWater.id) {
      return (a, b) => a.waterUseM3.compareTo(b.waterUseM3);
    }
    if (priority.id == MockCatalog.restoreSoil.id) {
      return (a, b) {
        final bySoil = b.soilImpact.score.compareTo(a.soilImpact.score);
        return bySoil != 0 ? bySoil : _compareWorst(a, b, scenario);
      };
    }
    return null;
  }

  static int _compareHarvest(
    RotationOption a,
    RotationOption b,
    ClimateScenario scenario,
  ) {
    final byExpected = b
        .outcomeFor(scenario)
        .expectedHarvest
        .compareTo(a.outcomeFor(scenario).expectedHarvest);
    return byExpected != 0 ? byExpected : _compareWorst(a, b, scenario);
  }

  /// Primero la que más cosecha salva en un mal año.
  static int _compareWorst(
    RotationOption a,
    RotationOption b,
    ClimateScenario scenario,
  ) => b
      .outcomeFor(scenario)
      .worstHarvest
      .compareTo(a.outcomeFor(scenario).worstHarvest);
}
