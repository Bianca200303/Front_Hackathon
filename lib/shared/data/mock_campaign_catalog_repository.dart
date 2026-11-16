import 'package:siembra_segura/core/l10n/app_language.dart';
import 'package:siembra_segura/shared/data/mock_catalog.dart';
import 'package:siembra_segura/shared/data/mock_text.dart';
import 'package:siembra_segura/shared/domain/campaign_catalog.dart';

/// Catálogo de ejemplo de la referencia (mvp.html).
class MockCampaignCatalogRepository implements CampaignCatalogRepository {
  /// Crea el repositorio; [latency] simula la espera de la red y
  /// [language] es el idioma de los textos.
  const MockCampaignCatalogRepository({
    this.latency = Duration.zero,
    this.language = AppLanguage.spanish,
  });

  /// Espera simulada antes de responder.
  final Duration latency;

  /// Idioma de los textos de ejemplo.
  final AppLanguage language;

  @override
  Future<CampaignCatalog> getCatalog() async {
    await Future<void>.delayed(latency);
    final t = MockText(language);
    final catalog = MockCatalog.catalog;
    return CampaignCatalog(
      priorities: [for (final p in catalog.priorities) t.priority(p)],
      restrictions: [for (final r in catalog.restrictions) t.restriction(r)],
      soilTextures: [for (final s in catalog.soilTextures) t.soilTexture(s)],
      soilTextureQuestion: t(catalog.soilTextureQuestion),
      maxRotationCrops: catalog.maxRotationCrops,
    );
  }
}
