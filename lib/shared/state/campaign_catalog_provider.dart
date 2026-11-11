import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:siembra_segura/core/config/app_config.dart';
import 'package:siembra_segura/core/config/mock_latency.dart';
import 'package:siembra_segura/shared/data/mock_campaign_catalog_repository.dart';
import 'package:siembra_segura/shared/data/remote_pending.dart';
import 'package:siembra_segura/shared/domain/campaign_catalog.dart';

/// Repositorio del catálogo según la fuente de datos configurada.
final campaignCatalogRepositoryProvider = Provider<CampaignCatalogRepository>((
  ref,
) {
  return switch (ref.watch(appConfigProvider).dataSource) {
    DataSourceMode.mock => MockCampaignCatalogRepository(
      latency: ref.watch(mockLatencyProvider),
    ),
    DataSourceMode.remote => remoteDataSourcePending('CampaignCatalog'),
  };
});

/// Prioridades y restricciones entre las que elige el agricultor.
final campaignCatalogProvider = FutureProvider<CampaignCatalog>(
  (ref) => ref.watch(campaignCatalogRepositoryProvider).getCatalog(),
);
