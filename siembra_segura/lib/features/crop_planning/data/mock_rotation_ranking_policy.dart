import 'package:siembra_segura/features/crop_planning/domain/crop_planning_models.dart';
import 'package:siembra_segura/features/crop_planning/domain/rotation_ranker.dart';
import 'package:siembra_segura/shared/data/mock_catalog.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';

/// Criterio de orden de la referencia (mvp.html), asociado a las
/// prioridades del catálogo de ejemplo.
///
/// - "Ganar más": mayor ganancia esperada en el escenario.
/// - "Cuidar mi agua": menor consumo de agua.
/// - "Recuperar mi tierra": mayor mejora del suelo y, a igualdad, menor
///   pérdida máxima en el escenario.
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
    if (priority.id == MockCatalog.maximizeProfit.id) {
      return (a, b) => b
          .outcomeFor(scenario)
          .expectedProfit
          .compareTo(a.outcomeFor(scenario).expectedProfit);
    }
    if (priority.id == MockCatalog.saveWater.id) {
      return (a, b) => a.waterUseM3.compareTo(b.waterUseM3);
    }
    if (priority.id == MockCatalog.restoreSoil.id) {
      return (a, b) => _compareSoil(a, b, scenario);
    }
    return null;
  }

  static int _compareSoil(
    RotationOption a,
    RotationOption b,
    ClimateScenario scenario,
  ) {
    final bySoil = b.soilImpact.score.compareTo(a.soilImpact.score);
    if (bySoil != 0) return bySoil;
    return a
        .outcomeFor(scenario)
        .maxLoss
        .compareTo(b.outcomeFor(scenario).maxLoss);
  }
}
