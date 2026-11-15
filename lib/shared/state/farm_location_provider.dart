import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:siembra_segura/shared/data/pilot_farm_location.dart';
import 'package:siembra_segura/shared/domain/farm_location.dart';
import 'package:siembra_segura/shared/state/campaign_context_provider.dart';

/// Ubicación de la parcela activa: la que el agricultor marcó en el mapa o,
/// si no marcó ninguna, el centro de la zona piloto.
///
/// El nombre del valle sigue siendo el de la zona piloto: la app no puede
/// resolverlo a partir de las coordenadas (decisión B4).
final farmLocationProvider = Provider<FarmLocation>((ref) {
  final latitude = ref.watch(
    campaignContextProvider.select((context) => context.farmLatitude),
  );
  final longitude = ref.watch(
    campaignContextProvider.select((context) => context.farmLongitude),
  );
  if (latitude == null || longitude == null) return pilotFarmLocation;
  return FarmLocation(
    valleyName: pilotFarmLocation.valleyName,
    latitude: latitude,
    longitude: longitude,
  );
});
