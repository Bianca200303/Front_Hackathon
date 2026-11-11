import 'package:equatable/equatable.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';

/// Parcela del agricultor y datos de contexto.
///
/// La geometría y la imagen satelital reales dependen del backend
/// (decisión B4); hoy la pantalla muestra una ilustración.
class Farm extends Equatable {
  /// Crea la parcela.
  const Farm({
    required this.farmerName,
    required this.valleyName,
    required this.areaHectares,
    required this.irrigationSource,
    required this.inferredLastCrop,
    required this.lastCropOptions,
  });

  /// Cómo se saluda al agricultor (p. ej., "Doña Rosa").
  final String farmerName;

  /// Valle en el que está la parcela.
  final String valleyName;

  /// Superficie, en hectáreas.
  final double areaHectares;

  /// Fuente de agua de riego (p. ej., el reservorio "Poechos").
  final String irrigationSource;

  /// Cultivo de la última campaña según el satélite.
  final Crop inferredLastCrop;

  /// Cultivos entre los que el agricultor puede corregir al satélite.
  final List<Crop> lastCropOptions;

  @override
  List<Object?> get props => [
    farmerName,
    valleyName,
    areaHectares,
    irrigationSource,
    inferredLastCrop,
    lastCropOptions,
  ];
}

/// Fuente de datos de la parcela.
abstract interface class FarmRepository {
  /// Devuelve la parcela del agricultor.
  Future<Farm> getFarm();
}
