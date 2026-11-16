import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

/// Resultado de pedir la ubicación del celular.
sealed class DeviceLocationResult {
  const DeviceLocationResult();
}

/// El celular dio su ubicación.
final class LocationFound extends DeviceLocationResult {
  /// Crea el resultado con las coordenadas en grados decimales.
  const LocationFound({required this.latitude, required this.longitude});

  /// Latitud.
  final double latitude;

  /// Longitud.
  final double longitude;
}

/// El agricultor no dio permiso (o lo negó para siempre).
final class LocationDenied extends DeviceLocationResult {
  /// Crea el resultado.
  const LocationDenied();
}

/// El GPS está apagado, no responde a tiempo o el navegador no lo ofrece.
final class LocationUnavailable extends DeviceLocationResult {
  /// Crea el resultado.
  const LocationUnavailable();
}

/// Ubicación del celular, para marcar la chacra con un toque.
abstract interface class DeviceLocationService {
  /// Pide permiso si hace falta y devuelve dónde está el celular.
  Future<DeviceLocationResult> current();
}

/// Implementación con `geolocator` (Android, iOS y web).
class GeolocatorLocationService implements DeviceLocationService {
  /// Crea el servicio; [timeLimit] corta la espera del GPS.
  const GeolocatorLocationService({
    this.timeLimit = const Duration(seconds: 15),
  });

  /// Espera máxima por una posición.
  final Duration timeLimit;

  @override
  Future<DeviceLocationResult> current() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return const LocationUnavailable();
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return const LocationDenied();
      }
      final position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(timeLimit: timeLimit),
      );
      return LocationFound(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } on Exception {
      // Sin GPS, tiempo agotado o navegador sin permiso: se marca a mano.
      return const LocationUnavailable();
    }
  }
}

/// Servicio de ubicación vigente; los tests lo reemplazan por uno falso.
final deviceLocationServiceProvider = Provider<DeviceLocationService>(
  (ref) => const GeolocatorLocationService(),
);
