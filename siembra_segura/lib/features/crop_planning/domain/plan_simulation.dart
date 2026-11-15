import 'package:equatable/equatable.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';

/// Cultivo que se puede elegir en "Prueba tu propio plan".
class SimulationCrop extends Equatable {
  /// Crea la opción.
  const SimulationCrop({
    required this.crop,
    this.harvested = true,
    this.excludedBy = const {},
  });

  /// Cultivo.
  final Crop crop;

  /// `false` para el abono verde: se siembra para abonar, no se cosecha.
  final bool harvested;

  /// Restricciones del agricultor que lo descartan (ids del catálogo).
  final Set<String> excludedBy;

  @override
  List<Object?> get props => [crop, harvested, excludedBy];
}

/// Qué pasaría en una campaña del plan.
class SimulatedCampaign extends Equatable {
  /// Crea el resultado de una campaña.
  const SimulatedCampaign({
    required this.crop,
    required this.harvest,
    required this.soilAfter,
  });

  /// Cultivo sembrado.
  final Crop crop;

  /// Cosecha (1 = una buena campaña), o `null` si no se cosecha (abono
  /// verde).
  final double? harvest;

  /// Estado de la tierra al terminar la campaña.
  final SoilCondition soilAfter;

  @override
  List<Object?> get props => [crop, harvest, soilAfter];
}

/// Resultado de un plan de varias campañas.
class PlanSimulation extends Equatable {
  /// Crea el resultado.
  const PlanSimulation({required this.campaigns, required this.waterUseM3});

  /// Una por campaña, en orden.
  final List<SimulatedCampaign> campaigns;

  /// Agua por hectárea en todo el plan, en m³.
  final int waterUseM3;

  /// Cosecha promedio de las campañas que se cosechan (0 si ninguna).
  double get averageHarvest {
    final harvests = [for (final campaign in campaigns) ?campaign.harvest];
    if (harvests.isEmpty) return 0;
    return harvests.reduce((a, b) => a + b) / harvests.length;
  }

  /// Estado de la tierra al final del plan.
  SoilCondition get soilAfter => campaigns.last.soilAfter;

  @override
  List<Object?> get props => [campaigns, waterUseM3];
}

/// Calcula cómo le iría al agricultor con un plan que arma él mismo.
///
/// Con datos reales lo calcula el modelo del backend (decisión B17); el de
/// ejemplo vive en `data/`.
abstract interface class PlanSimulator {
  /// Cultivos entre los que se puede elegir.
  Future<List<SimulationCrop>> availableCrops();

  /// Simula [plan] (un cultivo por campaña), partiendo de [previousCrop]
  /// (lo último que se sembró) y de la tierra en [soilToday]. La primera
  /// campaña tiene el clima [firstSeason]; las siguientes, un año normal.
  Future<PlanSimulation> simulate({
    required List<Crop> plan,
    required Crop previousCrop,
    required SoilCondition soilToday,
    required ClimateScenario firstSeason,
  });
}
