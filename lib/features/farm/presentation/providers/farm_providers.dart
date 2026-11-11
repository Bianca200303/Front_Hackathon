import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:siembra_segura/core/config/app_config.dart';
import 'package:siembra_segura/core/config/mock_latency.dart';
import 'package:siembra_segura/features/farm/data/mock_farm_repository.dart';
import 'package:siembra_segura/features/farm/domain/farm.dart';
import 'package:siembra_segura/shared/data/remote_pending.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';
import 'package:siembra_segura/shared/state/campaign_context_provider.dart';

/// Repositorio de la parcela según la fuente de datos configurada.
final farmRepositoryProvider = Provider<FarmRepository>((ref) {
  return switch (ref.watch(appConfigProvider).dataSource) {
    DataSourceMode.mock => MockFarmRepository(
      latency: ref.watch(mockLatencyProvider),
    ),
    DataSourceMode.remote => remoteDataSourcePending('Farm'),
  };
});

/// Parcela del agricultor.
final farmProvider = FutureProvider<Farm>(
  (ref) => ref.watch(farmRepositoryProvider).getFarm(),
);

/// Cultivo de la última campaña: el que eligió el agricultor o, si no
/// eligió (o lo que eligió ya no está entre las opciones), el que infirió
/// el satélite.
final selectedLastCropProvider = Provider.family<Crop, Farm>((ref, farm) {
  final chosenId = ref.watch(
    campaignContextProvider.select((context) => context.lastCropId),
  );
  return farm.lastCropOptions
          .where((crop) => crop.id == chosenId)
          .firstOrNull ??
      farm.inferredLastCrop;
});
