import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:siembra_segura/shared/data/pilot_farm_location.dart';
import 'package:siembra_segura/shared/domain/farm_location.dart';

/// Ubicación de la parcela activa. Hasta que el backend registre parcelas
/// (decisión B4) es la zona piloto.
final farmLocationProvider = Provider<FarmLocation>(
  (ref) => pilotFarmLocation,
);
