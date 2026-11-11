import 'package:siembra_segura/features/crop_planning/data/mock_crop_planning_repository.dart';
import 'package:siembra_segura/features/crop_planning/data/mock_rotation_ranking_policy.dart';
import 'package:siembra_segura/features/crop_planning/domain/crop_planning_models.dart';
import 'package:siembra_segura/features/crop_planning/domain/get_recommendation.dart';
import 'package:siembra_segura/features/crop_planning/domain/rotation_ranker.dart';
import 'package:siembra_segura/shared/data/mock_catalog.dart';
import 'package:siembra_segura/shared/data/mock_seasonal_outlook_repository.dart';
import 'package:siembra_segura/shared/domain/campaign_catalog.dart';
import 'package:siembra_segura/shared/domain/seasonal_outlook.dart';

/// Los datos de la referencia, que son los que usan los mocks.
Future<CropPlanningData> referencePlanningData() =>
    MockCropPlanningRepository().getPlanningData();

/// Pronóstico de la referencia (70 % lluvias fuertes).
Future<SeasonalOutlook> referenceOutlook() =>
    const MockSeasonalOutlookRepository().getOutlook();

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
