import 'package:siembra_segura/features/crop_planning/data/mock_crop_planning_repository.dart';
import 'package:siembra_segura/features/crop_planning/data/mock_rotation_ranking_policy.dart';
import 'package:siembra_segura/features/crop_planning/domain/crop_planning_models.dart';
import 'package:siembra_segura/features/crop_planning/domain/get_recommendation.dart';
import 'package:siembra_segura/features/crop_planning/domain/rotation_ranker.dart';
import 'package:siembra_segura/shared/data/mock_catalog.dart';
import 'package:siembra_segura/shared/data/pilot_farm_location.dart';
import 'package:siembra_segura/shared/domain/campaign_catalog.dart';

/// Consulta de ejemplo; los mocks la ignoran.
final referenceQuery = CropPlanningQuery(
  location: pilotFarmLocation,
  areaHectares: 2,
  plantingDate: DateTime(2026, 12, 15),
  consecutiveCampaigns: 3,
);

/// Los datos de la referencia, que son los que usan los mocks.
Future<CropPlanningData> referencePlanningData() =>
    MockCropPlanningRepository().getPlanningData(referenceQuery);

/// Catálogo de la referencia.
CampaignCatalog get referenceCatalog => MockCatalog.catalog;

/// Caso de uso con el criterio de orden de la referencia.
const referenceGetRecommendation = GetRecommendation(
  ranker: RotationRanker(MockRotationRankingPolicy()),
);

/// Identificadores de una lista de opciones, para comparar órdenes.
extension OptionIds on List<RotationOption> {
  /// Identificadores en orden.
  List<String> get ids => [for (final option in this) option.id];
}
