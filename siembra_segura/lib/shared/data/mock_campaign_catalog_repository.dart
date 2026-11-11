import 'package:siembra_segura/shared/data/mock_catalog.dart';
import 'package:siembra_segura/shared/domain/campaign_catalog.dart';

/// Catálogo de ejemplo de la referencia (mvp.html).
class MockCampaignCatalogRepository implements CampaignCatalogRepository {
  /// Crea el repositorio; [latency] simula la espera de la red.
  const MockCampaignCatalogRepository({this.latency = Duration.zero});

  /// Espera simulada antes de responder.
  final Duration latency;

  @override
  Future<CampaignCatalog> getCatalog() async {
    await Future<void>.delayed(latency);
    return MockCatalog.catalog;
  }
}
