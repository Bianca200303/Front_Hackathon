import 'package:equatable/equatable.dart';

/// Dónde está la parcela, para pedir datos climáticos y satelitales.
class FarmLocation extends Equatable {
  /// Crea la ubicación con coordenadas en grados decimales.
  const FarmLocation({
    required this.valleyName,
    required this.latitude,
    required this.longitude,
  });

  /// Valle en el que está la parcela (p. ej., "Medio Piura").
  final String valleyName;

  /// Latitud, de -90 a 90.
  final double latitude;

  /// Longitud, de -180 a 180.
  final double longitude;

  @override
  List<Object?> get props => [valleyName, latitude, longitude];
}
