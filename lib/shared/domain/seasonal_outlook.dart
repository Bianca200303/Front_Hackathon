import 'package:equatable/equatable.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';

/// Probabilidad de cada escenario climático hasta el fin del horizonte.
///
/// La consumen "Clima" y "Qué sembrar"; por eso vive en `shared`.
class SeasonalOutlook extends Equatable {
  /// Crea el pronóstico. Debe incluir al menos un escenario.
  SeasonalOutlook({
    required Map<ClimateScenario, double> probabilities,
    required this.horizonEnd,
  }) : assert(probabilities.isNotEmpty),
       probabilities = Map.unmodifiable(probabilities);

  /// Probabilidad (0 a 1) de cada escenario.
  final Map<ClimateScenario, double> probabilities;

  /// Mes hasta el que aplica el pronóstico (p. ej., marzo).
  final DateTime horizonEnd;

  /// Escenario con mayor probabilidad.
  ClimateScenario get mostLikely => probabilities.entries
      .reduce((best, entry) => entry.value > best.value ? entry : best)
      .key;

  /// Probabilidad de [scenario], o 0 si no viene en los datos.
  double probabilityOf(ClimateScenario scenario) =>
      probabilities[scenario] ?? 0;

  @override
  List<Object?> get props => [probabilities, horizonEnd];
}

/// Fuente del pronóstico estacional (ENFEN).
abstract interface class SeasonalOutlookRepository {
  /// Devuelve el pronóstico vigente.
  Future<SeasonalOutlook> getOutlook();
}
