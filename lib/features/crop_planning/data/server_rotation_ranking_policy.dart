import 'package:siembra_segura/features/crop_planning/domain/rotation_ranker.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';

/// Política para cuando ordena el backend (decisión 13).
///
/// El orden de cada prioridad y escenario llega en
/// `CropPlanningData.ranking`, así que aquí no hay criterio local: devuelve
/// siempre `null`.
class ServerRotationRankingPolicy implements RotationRankingPolicy {
  /// Crea la política.
  const ServerRotationRankingPolicy();

  @override
  RotationComparator? comparatorFor(
    CampaignPriority priority,
    ClimateScenario scenario,
  ) => null;
}
