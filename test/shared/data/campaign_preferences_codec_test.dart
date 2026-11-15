import 'package:flutter_test/flutter_test.dart';
import 'package:siembra_segura/shared/data/campaign_preferences_codec.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';
import 'package:siembra_segura/shared/domain/campaign_context.dart';

void main() {
  test('conserva todas las preferencias guardables', () {
    final context = CampaignContext(
      lastCropId: 'rice',
      priorityId: 'save-water',
      restrictionIds: const {'low-water'},
      areaHectares: 2.5,
      plantingDate: DateTime(2026, 12, 15),
      consecutiveCampaigns: 3,
      farmLatitude: -5.21,
      farmLongitude: -80.59,
      customRotation: const ['rice', 'bean'],
      soilTexture: SoilTexture.clayey,
    );

    final decoded = CampaignPreferencesCodec.decode(
      CampaignPreferencesCodec.encode(context),
    );

    expect(decoded, context);
  });

  test('una textura desconocida se descarta sin romper el resto', () {
    final saved = CampaignPreferencesCodec.encode(
      const CampaignContext(lastCropId: 'rice'),
    ).replaceFirst('"soilTexture":null', '"soilTexture":"marciana"');

    final decoded = CampaignPreferencesCodec.decode(saved);

    expect(decoded?.lastCropId, 'rice');
    expect(decoded?.soilTexture, isNull);
  });

  test('sin preferencias elegidas vuelve el contexto vacío', () {
    const empty = CampaignContext();

    expect(
      CampaignPreferencesCodec.decode(CampaignPreferencesCodec.encode(empty)),
      empty,
    );
  });

  test('un contenido dañado o de otra versión se descarta', () {
    expect(CampaignPreferencesCodec.decode('{'), isNull);
    expect(CampaignPreferencesCodec.decode('{"v":3}'), isNull);
    expect(CampaignPreferencesCodec.decode('[]'), isNull);
    expect(CampaignPreferencesCodec.decode('{"v":3,"lastCropId":7}'), isNull);
  });
}
