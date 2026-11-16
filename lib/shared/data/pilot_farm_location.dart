import 'package:siembra_segura/shared/domain/farm_location.dart';

/// Chacra demo del proyecto: margen norte del valle del Chira, frente a
/// Sullana (Marcavelica). El backend la deja en caché con
/// `scripts/warm_demo_farms.py`.
const pilotFarmLocation = FarmLocation(
  valleyName: 'Valle del Chira',
  latitude: -4.865,
  longitude: -80.72,
);

/// Recuadro del valle del Chira en el que se puede marcar la parcela:
/// desde Poechos hasta el Chira bajo; Sullana y Amotape quedan dentro.
const pilotValleyBounds = FarmBounds(
  south: -5,
  north: -4.7,
  west: -81.1,
  east: -80.5,
);
