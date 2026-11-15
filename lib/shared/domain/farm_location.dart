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

/// Recuadro en el que el agricultor puede marcar su parcela.
///
/// Acota el mapa al valle: fuera de ahí los datos satelitales son de otra
/// zona y la recomendación no tendría sentido.
class FarmBounds extends Equatable {
  /// Crea el recuadro; el sur y el oeste deben ser menores que el norte y
  /// el este.
  const FarmBounds({
    required this.south,
    required this.north,
    required this.west,
    required this.east,
  }) : assert(south < north && west < east);

  /// Latitud mínima.
  final double south;

  /// Latitud máxima.
  final double north;

  /// Longitud mínima.
  final double west;

  /// Longitud máxima.
  final double east;

  /// Posición relativa (0..1) de [location] dentro del recuadro, con el
  /// origen arriba a la izquierda, como en la pantalla.
  (double, double) fractionOf(FarmLocation location) => (
    ((location.longitude - west) / (east - west)).clamp(0.0, 1.0),
    ((north - location.latitude) / (north - south)).clamp(0.0, 1.0),
  );

  /// Coordenadas de un punto dado en fracciones de ancho y alto.
  (double, double) locationAt(double xFraction, double yFraction) => (
    north - (north - south) * yFraction.clamp(0.0, 1.0),
    west + (east - west) * xFraction.clamp(0.0, 1.0),
  );

  @override
  List<Object?> get props => [south, north, west, east];
}
