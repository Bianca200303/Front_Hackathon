import 'package:flutter_test/flutter_test.dart';
import 'package:siembra_segura/core/error/app_exception.dart';
import 'package:siembra_segura/core/network/api_client.dart';
import 'package:siembra_segura/shared/data/remote_campaign_catalog_repository.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';

class _FakeApiClient implements ApiClient {
  _FakeApiClient(this.response);

  final Object? response;
  String? path;

  @override
  Future<Object?> get(String path, {Map<String, String>? query}) async {
    this.path = path;
    return response;
  }

  @override
  Future<Object?> post(String path, {Object? body}) =>
      throw UnimplementedError();
}

Map<String, Object?> _catalogJson() => {
  'crops': [
    {
      'id': 'rice',
      'name': 'Arroz',
      'cycle_months': 5,
      'soil_impact': 'degrades',
      'water_need': 'high',
      'water_index': 5.3,
      'fixes_nitrogen': false,
    },
  ],
  'priorities': [
    {
      'id': 'lower-climate-risk',
      'name': 'Menos riesgo de clima',
      'phrase': 'tener menos riesgo de clima',
    },
    {'id': 'save-water', 'name': 'Cuidar mi agua', 'phrase': 'cuidar tu agua'},
  ],
  'restrictions': [
    {'id': 'low-water', 'name': 'Tendré poca agua'},
  ],
  'soil_textures': [
    {'id': 'sandy', 'name': 'Arenosa', 'description': 'Se desarma en la mano.'},
    {'id': 'clayey', 'name': 'Arcillosa', 'description': 'Se pega.'},
  ],
  'soil_texture_question': '¿A cuál se parece tu tierra?',
  'max_rotation_crops': 3,
  'example_parameters': true,
};

void main() {
  test('pide el catálogo y lo convierte al dominio', () async {
    final api = _FakeApiClient(_catalogJson());
    final repository = RemoteCampaignCatalogRepository(apiClient: api);

    final catalog = await repository.getCatalog();

    expect(api.path, RemoteCampaignCatalogRepository.path);
    expect(catalog.priorities, const [
      CampaignPriority(
        id: 'lower-climate-risk',
        name: 'Menos riesgo de clima',
        phrase: 'tener menos riesgo de clima',
      ),
      CampaignPriority(
        id: 'save-water',
        name: 'Cuidar mi agua',
        phrase: 'cuidar tu agua',
      ),
    ]);
    expect(catalog.restrictions, const [
      CampaignRestriction(id: 'low-water', name: 'Tendré poca agua'),
    ]);
    expect(catalog.defaultPriority.id, 'lower-climate-risk');
    expect(catalog.maxRotationCrops, 3);
    expect(catalog.soilTextureQuestion, '¿A cuál se parece tu tierra?');
    expect(catalog.asksForSoilTexture, isTrue);
    expect(catalog.soilTextures, const [
      SoilTextureAnswer(
        texture: SoilTexture.sandy,
        name: 'Arenosa',
        description: 'Se desarma en la mano.',
      ),
      SoilTextureAnswer(
        texture: SoilTexture.clayey,
        name: 'Arcillosa',
        description: 'Se pega.',
      ),
    ]);
  });

  test('sin texturas no se puede preguntar por la tierra', () async {
    final json = _catalogJson()..['soil_textures'] = const [];
    final repository = RemoteCampaignCatalogRepository(
      apiClient: _FakeApiClient(json),
    );

    final catalog = await repository.getCatalog();

    expect(catalog.soilTextures, isEmpty);
    expect(catalog.asksForSoilTexture, isFalse);
  });

  test('una respuesta con otro formato lanza UnexpectedException', () async {
    final json = _catalogJson()..['priorities'] = 'no es una lista';
    final repository = RemoteCampaignCatalogRepository(
      apiClient: _FakeApiClient(json),
    );

    await expectLater(
      repository.getCatalog(),
      throwsA(isA<UnexpectedException>()),
    );
  });

  test('un catálogo sin prioridades lanza UnexpectedException', () async {
    final json = _catalogJson()..['priorities'] = const [];
    final repository = RemoteCampaignCatalogRepository(
      apiClient: _FakeApiClient(json),
    );

    await expectLater(
      repository.getCatalog(),
      throwsA(isA<UnexpectedException>()),
    );
  });
}
