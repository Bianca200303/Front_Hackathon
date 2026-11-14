import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:siembra_segura/core/config/mock_latency.dart';
import 'package:siembra_segura/shared/data/mock_campaign_catalog_repository.dart';
import 'package:siembra_segura/shared/domain/campaign_catalog.dart';

/// Repositorio del catálogo. Usa datos de ejemplo también con
/// `DATA_SOURCE=remote` hasta que el backend lo exponga (B12).
final campaignCatalogRepositoryProvider = Provider<CampaignCatalogRepository>(
  (ref) =>
      MockCampaignCatalogRepository(latency: ref.watch(mockLatencyProvider)),
);

/// Prioridades y restricciones entre las que elige el agricultor.
final campaignCatalogProvider = FutureProvider<CampaignCatalog>(
  (ref) => ref.watch(campaignCatalogRepositoryProvider).getCatalog(),
);
