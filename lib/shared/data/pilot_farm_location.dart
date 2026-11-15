import 'package:siembra_segura/shared/domain/farm_location.dart';

/// Zona piloto del proyecto; coincide con `DEFAULT_LAT/LON` del backend.
const pilotFarmLocation = FarmLocation(
  valleyName: 'Medio Piura',
  latitude: -5.19,
  longitude: -80.63,
);

/// Recuadro del valle piloto en el que se puede marcar la parcela.
const pilotValleyBounds = FarmBounds(
  south: -5.45,
  north: -4.95,
  west: -80.90,
  east: -80.35,
);
