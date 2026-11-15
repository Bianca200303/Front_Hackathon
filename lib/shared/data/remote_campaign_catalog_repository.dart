import 'package:siembra_segura/core/error/app_exception.dart';
import 'package:siembra_segura/core/network/api_client.dart';
import 'package:siembra_segura/core/network/json_object.dart';
import 'package:siembra_segura/shared/data/soil_texture_ids.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';
import 'package:siembra_segura/shared/domain/campaign_catalog.dart';

/// Catálogo desde el backend (`GET /api/v1/app/catalog`): prioridades,
/// restricciones, las texturas con las que el agricultor reconoce su tierra
/// y cuántos cultivos puede encadenar.
///
/// Los cultivos del catálogo todavía no se usan: el cultivo de la última
/// campaña sale de la parcela (`Farm.lastCropOptions`, decisión B4).
class RemoteCampaignCatalogRepository implements CampaignCatalogRepository {
  /// Crea el repositorio.
  const RemoteCampaignCatalogRepository({required this.apiClient});

  /// Cliente del backend.
  final ApiClient apiClient;

  /// Ruta del recurso, relativa a `API_BASE_URL`.
  static const path = 'api/v1/app/catalog';

  @override
  Future<CampaignCatalog> getCatalog() async {
    final body = await apiClient.get(path);
    try {
      final json = JsonObject(body);
      return CampaignCatalog(
        maxRotationCrops: json.integer('max_rotation_crops'),
        priorities: [
          for (final priority in json.objects('priorities'))
            CampaignPriority(
              id: priority.string('id'),
              name: priority.string('name'),
              phrase: priority.string('phrase'),
            ),
        ],
        restrictions: [
          for (final restriction in json.objects('restrictions'))
            CampaignRestriction(
              id: restriction.string('id'),
              name: restriction.string('name'),
            ),
        ],
        soilTextureQuestion: json.string('soil_texture_question'),
        soilTextures: [
          for (final texture in json.objects('soil_textures'))
            SoilTextureAnswer(
              texture: texture.oneOf('id', SoilTextureIds.byId),
              name: texture.string('name'),
              description: texture.string('description'),
            ),
        ],
      );
    } on FormatException catch (error) {
      throw UnexpectedException(error);
    } on AssertionError catch (error) {
      // El catálogo necesita al menos una prioridad.
      throw UnexpectedException(error);
    }
  }
}
