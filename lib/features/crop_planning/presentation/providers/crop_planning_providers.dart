import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:siembra_segura/core/config/app_config.dart';
import 'package:siembra_segura/core/config/mock_latency.dart';
import 'package:siembra_segura/core/network/http_api_client.dart';
import 'package:siembra_segura/core/utils/async_value_combine.dart';
import 'package:siembra_segura/features/crop_planning/data/mock_crop_planning_repository.dart';
import 'package:siembra_segura/features/crop_planning/data/mock_rotation_ranking_policy.dart';
import 'package:siembra_segura/features/crop_planning/data/remote_crop_planning_repository.dart';
import 'package:siembra_segura/features/crop_planning/data/server_rotation_ranking_policy.dart';
import 'package:siembra_segura/features/crop_planning/domain/crop_planning_models.dart';
import 'package:siembra_segura/features/crop_planning/domain/get_recommendation.dart';
import 'package:siembra_segura/features/crop_planning/domain/recommendation.dart';
import 'package:siembra_segura/features/crop_planning/domain/rotation_ranker.dart';
import 'package:siembra_segura/shared/state/campaign_catalog_provider.dart';
import 'package:siembra_segura/shared/state/campaign_context_provider.dart';
import 'package:siembra_segura/shared/state/farm_location_provider.dart';

/// Repositorio de planificación: el backend con `DATA_SOURCE=remote`.
final cropPlanningRepositoryProvider = Provider<CropPlanningRepository>((ref) {
  if (ref.watch(appConfigProvider).usesMocks) {
    return MockCropPlanningRepository(latency: ref.watch(mockLatencyProvider));
  }
  return RemoteCropPlanningRepository(apiClient: ref.watch(apiClientProvider));
});

/// Criterio para ordenar las rotaciones por prioridad (decisión 13). Con el
/// backend el orden ya viene en los datos.
final rotationRankingPolicyProvider = Provider<RotationRankingPolicy>(
  (ref) => ref.watch(appConfigProvider).usesMocks
      ? const MockRotationRankingPolicy()
      : const ServerRotationRankingPolicy(),
);

/// Lo que el agricultor ingresó y condiciona el cálculo. Al cambiar, se
/// vuelven a pedir los datos (la prioridad y las restricciones no).
final cropPlanningQueryProvider = Provider<CropPlanningQuery>(
  (ref) => CropPlanningQuery(
    location: ref.watch(farmLocationProvider),
    areaHectares: ref.watch(selectedAreaHectaresProvider),
    plantingDate: ref.watch(selectedPlantingDateProvider),
    consecutiveCampaigns: ref.watch(selectedConsecutiveCampaignsProvider),
    lastCropId: ref.watch(
      campaignContextProvider.select((context) => context.lastCropId),
    ),
    customRotation: ref.watch(
      campaignContextProvider.select((context) => context.customRotation),
    ),
    reportedSoilTexture: ref.watch(
      campaignContextProvider.select((context) => context.soilTexture),
    ),
  ),
);

/// Opciones de rotación, práctica actual y estado del suelo.
final planningDataProvider = FutureProvider<CropPlanningData>(
  (ref) => ref
      .watch(cropPlanningRepositoryProvider)
      .getPlanningData(ref.watch(cropPlanningQueryProvider)),
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
  return combineAsync(
    ref.watch(planningDataProvider),
    ref.watch(campaignCatalogProvider),
    (data, catalog) =>
        getRecommendation(data: data, catalog: catalog, context: context),
  );
});

/// Vuelve a pedir los datos de la recomendación (botón "Reintentar").
void retryRecommendation(WidgetRef ref) {
  ref
    ..invalidate(planningDataProvider)
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
