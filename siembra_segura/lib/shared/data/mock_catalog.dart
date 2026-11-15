import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';
import 'package:siembra_segura/shared/domain/campaign_catalog.dart';

/// Datos de ejemplo del catálogo, tomados de la referencia (mvp.html).
///
/// Es la única fuente de cultivos, prioridades y restricciones de los
/// repositorios mock, para que todos usen los mismos identificadores. Solo
/// la capa de datos puede importar este archivo.
abstract final class MockCatalog {
  /// Arroz.
  static const rice = Crop(id: 'rice', name: 'Arroz');

  /// Maíz.
  static const maize = Crop(id: 'maize', name: 'Maíz');

  /// Algodón.
  static const cotton = Crop(id: 'cotton', name: 'Algodón');

  /// Frejol.
  static const bean = Crop(id: 'bean', name: 'Frejol');

  /// Menestra.
  static const pulse = Crop(id: 'pulse', name: 'Menestra');

  /// Abono verde: se siembra para abonar la tierra, no para cosechar.
  static const greenManure = Crop(id: 'green-manure', name: 'Abono verde');

  /// Opción "Otro" para corregir al satélite.
  static const otherCrop = Crop(id: 'other', name: 'Otro');

  /// Prioridad "Que el clima no malogre mi cosecha" (como en
  /// `semi_app.html`). La app no trabaja con precios ni ganancias.
  static const protectHarvest = CampaignPriority(
    id: 'protect-harvest',
    name: 'Que el clima no malogre mi cosecha',
    phrase: 'que el clima no malogre tu cosecha',
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

  /// Catálogo completo, en el orden de la referencia.
  static final catalog = CampaignCatalog(
    priorities: const [protectHarvest, saveWater, restoreSoil],
    restrictions: const [noCottonBuyer, lowWater],
  );
}
