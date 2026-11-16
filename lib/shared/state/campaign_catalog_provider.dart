import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:siembra_segura/core/config/app_config.dart';
import 'package:siembra_segura/core/config/mock_latency.dart';
import 'package:siembra_segura/core/l10n/app_language_provider.dart';
import 'package:siembra_segura/core/network/http_api_client.dart';
import 'package:siembra_segura/shared/data/mock_campaign_catalog_repository.dart';
import 'package:siembra_segura/shared/data/remote_campaign_catalog_repository.dart';
import 'package:siembra_segura/shared/domain/campaign_catalog.dart';

/// Repositorio del catálogo: el backend con `DATA_SOURCE=remote`.
final campaignCatalogRepositoryProvider = Provider<CampaignCatalogRepository>((
  ref,
) {
  if (ref.watch(appConfigProvider).usesMocks) {
    return MockCampaignCatalogRepository(
      latency: ref.watch(mockLatencyProvider),
      language: ref.watch(appLanguageProvider),
    );
  }
  return RemoteCampaignCatalogRepository(
    apiClient: ref.watch(apiClientProvider),
  );
});

/// Prioridades y restricciones entre las que elige el agricultor.
final campaignCatalogProvider = FutureProvider<CampaignCatalog>(
  (ref) => ref.watch(campaignCatalogRepositoryProvider).getCatalog(),
);
