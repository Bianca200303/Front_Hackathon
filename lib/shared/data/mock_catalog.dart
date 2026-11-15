import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';
import 'package:siembra_segura/shared/domain/campaign_catalog.dart';

/// Datos de ejemplo del catálogo, tomados de la referencia (mvp.html).
///
/// Es la única fuente de cultivos, prioridades y restricciones de los
/// repositorios mock, para que todos usen los mismos identificadores. Solo
/// la capa de datos puede importar este archivo.
abstract final class MockCatalog {
  /// Arroz.
  static const rice = Crop(
    id: 'rice',
    name: 'Arroz',
    cycleMonths: 5,
    waterNeed: CropWaterNeed.high,
  );

  /// Maíz.
  static const maize = Crop(
    id: 'maize',
    name: 'Maíz',
    cycleMonths: 4,
    waterNeed: CropWaterNeed.medium,
  );

  /// Algodón.
  static const cotton = Crop(
    id: 'cotton',
    name: 'Algodón',
    cycleMonths: 6,
    waterNeed: CropWaterNeed.high,
  );

  /// Frejol.
  static const bean = Crop(
    id: 'bean',
    name: 'Frejol',
    cycleMonths: 4,
    waterNeed: CropWaterNeed.low,
    fixesNitrogen: true,
  );

  /// Menestra.
  static const pulse = Crop(
    id: 'pulse',
    name: 'Menestra',
    cycleMonths: 2,
    waterNeed: CropWaterNeed.low,
    fixesNitrogen: true,
  );

  /// Opción "Otro" para corregir al satélite.
  static const otherCrop = Crop(id: 'other', name: 'Otro');

  /// Prioridad "Menos riesgo de clima".
  static const lowerClimateRisk = CampaignPriority(
    id: 'lower-climate-risk',
    name: 'Menos riesgo de clima',
    phrase: 'tener menos riesgo de clima',
  );

  /// Prioridad "Cuidar mi agua".
  static const saveWater = CampaignPriority(
    id: 'save-water',
    name: 'Cuidar mi agua',
    phrase: 'cuidar tu agua',
  );

  /// Prioridad "Recuperar mi tierra".
  static const restoreSoil = CampaignPriority(
    id: 'restore-soil',
    name: 'Recuperar mi tierra',
    phrase: 'recuperar tu tierra',
  );

  /// Restricción "No tengo comprador para algodón".
  static const noCottonBuyer = CampaignRestriction(
    id: 'no-cotton-buyer',
    name: 'No tengo comprador para algodón',
  );

  /// Restricción "Tendré poca agua".
  static const lowWater = CampaignRestriction(
    id: 'low-water',
    name: 'Tendré poca agua',
  );

  /// Pregunta con la que se ofrecen las texturas.
  static const soilTextureQuestion = '¿A cuál de estas se parece tu tierra?';

  /// Texturas entre las que el agricultor reconoce su tierra.
  static const soilTextures = [
    SoilTextureAnswer(
      texture: SoilTexture.sandy,
      name: 'Arenosa',
      description:
          'Se desarma en la mano y se siente como arena. El agua se va '
          'rápido.',
    ),
    SoilTextureAnswer(
      texture: SoilTexture.loamy,
      name: 'Franca',
      description:
          'Se hace bola húmeda pero se rompe sin esfuerzo. Guarda bien el '
          'agua.',
    ),
    SoilTextureAnswer(
      texture: SoilTexture.clayey,
      name: 'Arcillosa',
      description:
          'Se pega en la mano y se parte en terrones duros al secarse. Se '
          'encharca.',
    ),
  ];

  /// Catálogo completo, en el orden de la referencia.
  static final catalog = CampaignCatalog(
    priorities: const [lowerClimateRisk, saveWater, restoreSoil],
    restrictions: const [noCottonBuyer, lowWater],
    soilTextures: soilTextures,
    soilTextureQuestion: soilTextureQuestion,
  );
}
