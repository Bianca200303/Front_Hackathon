import 'package:siembra_segura/features/crop_planning/domain/crop_planning_models.dart';
import 'package:siembra_segura/features/crop_planning/domain/rotation_ranker.dart';
import 'package:siembra_segura/shared/data/mock_catalog.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';

/// Criterio de orden para las prioridades del catálogo de ejemplo. Replica
/// el del servidor para que la app se vea igual con datos de ejemplo:
///
/// - "Cuidar mi agua": menos agua de riego.
/// - "Recuperar mi tierra": mayor mejora de la tierra y, a igualdad, menos
///   meses de riesgo.
/// - "Menos riesgo de clima": menos meses de riesgo y, a igualdad, menos
///   agua.
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
    if (priority.id == MockCatalog.saveWater.id) {
      return (a, b) => _byWater(a, b, scenario);
    }
    if (priority.id == MockCatalog.restoreSoil.id) {
      return (a, b) {
        final bySoil = b.soilImpact.index.compareTo(a.soilImpact.index);
        return bySoil != 0 ? bySoil : _byRisk(a, b, scenario);
      };
    }
    if (priority.id == MockCatalog.lowerClimateRisk.id) {
      return (a, b) {
        final byRisk = _byRisk(a, b, scenario);
        return byRisk != 0 ? byRisk : _byWater(a, b, scenario);
      };
    }
    return null;
  }

  static int _byWater(
    RotationOption a,
    RotationOption b,
    ClimateScenario scenario,
  ) {
    final water = a.resultFor(scenario).waterUseM3;
    return water.compareTo(b.resultFor(scenario).waterUseM3);
  }

  static int _byRisk(
    RotationOption a,
    RotationOption b,
    ClimateScenario scenario,
  ) {
    final months = a.resultFor(scenario).riskMonths.length;
    return months.compareTo(b.resultFor(scenario).riskMonths.length);
  }
}
