import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:siembra_segura/core/config/app_config.dart';
import 'package:siembra_segura/core/config/mock_latency.dart';
import 'package:siembra_segura/core/l10n/app_language_provider.dart';
import 'package:siembra_segura/core/utils/async_value_combine.dart';
import 'package:siembra_segura/features/crop_planning/data/mock_crop_planning_repository.dart';
import 'package:siembra_segura/features/crop_planning/data/mock_plan_simulator.dart';
import 'package:siembra_segura/features/crop_planning/data/mock_rotation_ranking_policy.dart';
import 'package:siembra_segura/features/crop_planning/domain/crop_planning_models.dart';
import 'package:siembra_segura/features/crop_planning/domain/get_recommendation.dart';
import 'package:siembra_segura/features/crop_planning/domain/plan_simulation.dart';
import 'package:siembra_segura/features/crop_planning/domain/recommendation.dart';
import 'package:siembra_segura/features/crop_planning/domain/rotation_ranker.dart';
import 'package:siembra_segura/shared/data/remote_pending.dart';
import 'package:siembra_segura/shared/state/campaign_catalog_provider.dart';
import 'package:siembra_segura/shared/state/campaign_context_provider.dart';
import 'package:siembra_segura/shared/state/seasonal_outlook_provider.dart';

/// Repositorio de planificación según la fuente de datos configurada.
final cropPlanningRepositoryProvider = Provider<CropPlanningRepository>((ref) {
  return switch (ref.watch(appConfigProvider).dataSource) {
    DataSourceMode.mock => MockCropPlanningRepository(
      latency: ref.watch(mockLatencyProvider),
      language: ref.watch(appLanguageProvider),
    ),
    DataSourceMode.remote => remoteDataSourcePending('CropPlanning'),
  };
});

/// Criterio para ordenar las rotaciones por prioridad (decisión B3).
final rotationRankingPolicyProvider = Provider<RotationRankingPolicy>((ref) {
  return switch (ref.watch(appConfigProvider).dataSource) {
    DataSourceMode.mock => const MockRotationRankingPolicy(),
    DataSourceMode.remote => remoteDataSourcePending('RotationRankingPolicy'),
  };
});

/// Opciones de rotación, práctica actual y estado del suelo.
final planningDataProvider = FutureProvider<CropPlanningData>(
  (ref) => ref.watch(cropPlanningRepositoryProvider).getPlanningData(),
);

/// Caso de uso que arma la recomendación.
final getRecommendationProvider = Provider<GetRecommendation>(
  (ref) => GetRecommendation(
    ranker: RotationRanker(ref.watch(rotationRankingPolicyProvider)),
  ),
);

/// Recomendación vigente. Se recalcula al instante (sin volver a pedir
/// datos) cuando cambian la prioridad, las restricciones o el escenario.
final recommendationProvider = Provider<AsyncValue<Recommendation>>((ref) {
  final context = ref.watch(campaignContextProvider);
  final getRecommendation = ref.watch(getRecommendationProvider);
  final inputs = combineAsync(
    ref.watch(planningDataProvider),
    ref.watch(seasonalOutlookProvider),
    (data, outlook) => (data: data, outlook: outlook),
  );
  return combineAsync(
    inputs,
    ref.watch(campaignCatalogProvider),
    (inputs, catalog) => getRecommendation(
      data: inputs.data,
      outlook: inputs.outlook,
      catalog: catalog,
      context: context,
    ),
  );
});

/// Vuelve a pedir los datos de la recomendación (botón "Reintentar").
void retryRecommendation(WidgetRef ref) {
  ref
    ..invalidate(planningDataProvider)
    ..invalidate(seasonalOutlookProvider)
    ..invalidate(campaignCatalogProvider);
}

final _recommendedRotationIdProvider = Provider<String?>((ref) {
  final recommendation = ref.watch(recommendationProvider).value;
  return recommendation != null && recommendation.hasOptions
      ? recommendation.best.id
      : null;
});

/// Estado del "Cuéntanos qué sembraste". `AsyncData(true)` = enviado.
///
/// Se reinicia cuando cambia la rotación recomendada.
class PlantingFeedbackNotifier extends Notifier<AsyncValue<bool>> {
  @override
  AsyncValue<bool> build() {
    ref.watch(_recommendedRotationIdProvider);
    return const AsyncData(false);
  }

  /// Envía si el agricultor siguió la recomendación o sembró otra cosa.
  Future<void> submit({required bool followedRecommendation}) async {
    final rotationId = ref.read(_recommendedRotationIdProvider);
    if (rotationId == null || state.isLoading) return;

    state = const AsyncLoading();
    final repository = ref.read(cropPlanningRepositoryProvider);
    final result = await AsyncValue.guard(() async {
      await repository.submitPlantingFeedback(
        PlantingFeedback(
          rotationId: rotationId,
          followedRecommendation: followedRecommendation,
        ),
      );
      return true;
    });
    if (ref.mounted) state = result;
  }
}

/// Envío de "Cuéntanos qué sembraste".
final plantingFeedbackProvider =
    NotifierProvider<PlantingFeedbackNotifier, AsyncValue<bool>>(
      PlantingFeedbackNotifier.new,
    );

/// Simulador de "Prueba tu propio plan" (decisión B17).
final planSimulatorProvider = Provider<PlanSimulator>((ref) {
  return switch (ref.watch(appConfigProvider).dataSource) {
    DataSourceMode.mock => MockPlanSimulator(
      latency: ref.watch(mockLatencyProvider),
      language: ref.watch(appLanguageProvider),
    ),
    DataSourceMode.remote => remoteDataSourcePending('PlanSimulator'),
  };
});

/// Cultivos entre los que se elige al armar un plan.
final simulationCropsProvider = FutureProvider<List<SimulationCrop>>(
  (ref) => ref.watch(planSimulatorProvider).availableCrops(),
);
