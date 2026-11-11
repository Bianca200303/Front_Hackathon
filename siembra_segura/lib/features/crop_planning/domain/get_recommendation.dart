import 'package:siembra_segura/features/crop_planning/domain/crop_planning_models.dart';
import 'package:siembra_segura/features/crop_planning/domain/recommendation.dart';
import 'package:siembra_segura/features/crop_planning/domain/rotation_ranker.dart';
import 'package:siembra_segura/shared/domain/campaign_catalog.dart';
import 'package:siembra_segura/shared/domain/campaign_context.dart';
import 'package:siembra_segura/shared/domain/seasonal_outlook.dart';

/// Caso de uso: construir la recomendación a partir de los datos, el
/// pronóstico, el catálogo y las decisiones del agricultor.
class GetRecommendation {
  /// Crea el caso de uso con el ordenador de rotaciones indicado.
  const GetRecommendation({required this.ranker});

  /// Ordena las opciones según la prioridad.
  final RotationRanker ranker;

  /// Calcula la recomendación vigente.
  Recommendation call({
    required CropPlanningData data,
    required SeasonalOutlook outlook,
    required CampaignCatalog catalog,
    required CampaignContext context,
  }) {
    // Sin elección explícita (o si ya no existe), se usan los valores
    // sugeridos: el escenario más probable y la prioridad por defecto.
    final scenario = context.selectedScenario ?? outlook.mostLikely;
    final priority = catalog.priorityOrDefault(context.priorityId);
    return Recommendation(
      scenario: scenario,
      priority: priority,
      outlook: outlook,
      data: data,
      rankedOptions: ranker.rank(
        options: data.options,
        scenario: scenario,
        priority: priority,
        restrictionIds: context.restrictionIds,
      ),
    );
  }
}
