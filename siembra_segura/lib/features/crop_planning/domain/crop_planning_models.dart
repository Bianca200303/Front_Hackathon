import 'package:equatable/equatable.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';

/// Cosecha que se espera de una opción en un escenario climático.
///
/// Se mide contra una buena campaña de esos cultivos en el valle (1 = una
/// cosecha completa), con datos de satélite de la NASA (verdor, lluvia y
/// humedad del suelo). La app no muestra precios ni ganancias.
class ScenarioOutcome extends Equatable {
  /// Crea el resultado de un escenario.
  const ScenarioOutcome({
    required this.expectedHarvest,
    required this.worstHarvest,
  });

  /// Cosecha más probable (0.85 = 85 % de una buena campaña).
  final double expectedHarvest;

  /// Cosecha si el año sale mal dentro del escenario.
  final double worstHarvest;

  @override
  List<Object?> get props => [expectedHarvest, worstHarvest];
}

/// Cuánto mejora la tierra una rotación.
enum SoilImpact {
  /// Mejora la tierra.
  improves(1),

  /// Mejora mucho la tierra.
  improvesALot(2);

  const SoilImpact(this.score);

  /// Mayor es mejor. Se usa para ordenar por "recuperar mi tierra".
  final int score;
}

/// Ficha explicativa: por qué, evidencia, beneficios, vacíos y riesgos.
///
/// Es contenido (previsiblemente del backend, decisión B11).
class OptionFactsheet extends Equatable {
  /// Crea la ficha con sus cinco secciones.
  const OptionFactsheet({
    required this.rationale,
    required this.evidence,
    required this.benefits,
    required this.unknowns,
    required this.risks,
  });

  /// Por qué se propone esta opción.
  final String rationale;

  /// Datos que la respaldan (satélite, FAO, históricos).
  final String evidence;

  /// Qué gana el agricultor.
  final String benefits;

  /// Lo que todavía no se sabe.
  final String unknowns;

  /// Riesgos y qué confirmar con el técnico.
  final String risks;

  @override
  List<Object?> get props => [rationale, evidence, benefits, unknowns, risks];
}

/// Tramo del calendario en el que un cultivo ocupa el campo.
class CropPeriod extends Equatable {
  /// Crea el tramo; [monthCount] debe ser positivo.
  const CropPeriod({
    required this.crop,
    required this.start,
    required this.monthCount,
  }) : assert(monthCount > 0);

  /// Cultivo que ocupa el campo.
  final Crop crop;

  /// Primer mes (se ignora el día).
  final DateTime start;

  /// Cuántos meses ocupa el campo.
  final int monthCount;

  @override
  List<Object?> get props => [crop, start, monthCount];
}

/// Calendario de siembra de una rotación.
class PlantingSchedule extends Equatable {
  /// Crea el calendario.
  const PlantingSchedule({
    required this.decisionDeadline,
    required this.timelineStart,
    required this.timelineMonths,
    required this.periods,
    required this.instructions,
  });

  /// Fecha límite para decidir qué sembrar.
  final DateTime decisionDeadline;

  /// Primer mes visible en el calendario.
  final DateTime timelineStart;

  /// Cantidad de meses visibles.
  final int timelineMonths;

  /// Tramos de cultivo, en orden.
  final List<CropPeriod> periods;

  /// Indicaciones de siembra en lenguaje simple.
  final String instructions;

  /// Meses visibles del calendario, en orden.
  List<DateTime> get months => [
    for (var i = 0; i < timelineMonths; i++)
      DateTime(timelineStart.year, timelineStart.month + i),
  ];

  @override
  List<Object?> get props => [
    decisionDeadline,
    timelineStart,
    timelineMonths,
    periods,
    instructions,
  ];
}

/// Una campaña del plan de largo plazo y cómo queda la tierra después.
class CampaignStep extends Equatable {
  /// Crea un paso del plan.
  const CampaignStep({
    required this.start,
    required this.end,
    required this.crop,
    required this.soilAfter,
  });

  /// Inicio de la campaña.
  final DateTime start;

  /// Fin de la campaña.
  final DateTime end;

  /// Cultivo de la campaña.
  final Crop crop;

  /// Estado estimado de la tierra al terminar.
  final SoilCondition soilAfter;

  @override
  List<Object?> get props => [start, end, crop, soilAfter];
}

/// Rotación de cultivos que se puede recomendar.
class RotationOption extends Equatable {
  /// Crea una opción de rotación.
  const RotationOption({
    required this.id,
    required this.crops,
    required this.waterUseM3,
    required this.waterSummary,
    required this.soilImpact,
    required this.soilInTwoYears,
    required this.factsheet,
    required this.outcomes,
    required this.schedule,
    required this.longTermPlan,
    this.excludedBy = const {},
  });

  /// Identificador estable de la opción.
  final String id;

  /// Cultivos en orden de siembra (p. ej., maíz y después frejol).
  final List<Crop> crops;

  /// Agua por hectárea y campaña, en m³.
  final int waterUseM3;

  /// Comparación de agua en lenguaje simple ("usa la mitad que el arroz").
  final String waterSummary;

  /// Cuánto mejora la tierra.
  final SoilImpact soilImpact;

  /// Estado estimado de la tierra en dos años.
  final SoilCondition soilInTwoYears;

  /// Ficha explicativa.
  final OptionFactsheet factsheet;

  /// Resultado económico por escenario.
  final Map<ClimateScenario, ScenarioOutcome> outcomes;

  /// Calendario de siembra.
  final PlantingSchedule schedule;

  /// Plan de las próximas campañas.
  final List<CampaignStep> longTermPlan;

  /// Restricciones del agricultor que descartan esta opción.
  final Set<String> excludedBy;

  /// Resultado en [scenario]. Lanza [StateError] si los datos no lo
  /// incluyen: es un error de contrato, no un caso esperado.
  ScenarioOutcome outcomeFor(ClimateScenario scenario) {
    final outcome = outcomes[scenario];
    if (outcome == null) {
      throw StateError('La opción $id no tiene resultados para $scenario.');
    }
    return outcome;
  }

  /// `true` si ninguna de las restricciones activas descarta la opción.
  bool isAllowedWith(Set<String> restrictionIds) =>
      excludedBy.intersection(restrictionIds).isEmpty;

  @override
  List<Object?> get props => [
    id,
    crops,
    waterUseM3,
    waterSummary,
    soilImpact,
    soilInTwoYears,
    factsheet,
    outcomes,
    schedule,
    longTermPlan,
    excludedBy,
  ];
}

/// Lo que el agricultor siembra hoy, como punto de comparación.
class CurrentPractice extends Equatable {
  /// Crea la práctica actual.
  const CurrentPractice({
    required this.crops,
    required this.waterUseM3,
    required this.soilInTwoYears,
    required this.expectedHarvest,
    required this.factsheet,
    required this.repeatWarnings,
    required this.consecutiveCampaigns,
  });

  /// Cultivos de la rotación actual. Nunca vacío.
  final List<Crop> crops;

  /// Agua por hectárea y campaña, en m³.
  final int waterUseM3;

  /// Estado estimado de la tierra en dos años si sigue igual.
  final SoilCondition soilInTwoYears;

  /// Cosecha esperada por escenario (1 = una buena campaña).
  final Map<ClimateScenario, double> expectedHarvest;

  /// Ficha explicativa.
  final OptionFactsheet factsheet;

  /// Qué pasa si repite el cultivo, según el escenario.
  final Map<ClimateScenario, String> repeatWarnings;

  /// Campañas seguidas con el mismo cultivo.
  final int consecutiveCampaigns;

  /// Cultivo principal (el primero de la rotación).
  Crop get mainCrop => crops.first;

  @override
  List<Object?> get props => [
    crops,
    waterUseM3,
    soilInTwoYears,
    expectedHarvest,
    factsheet,
    repeatWarnings,
    consecutiveCampaigns,
  ];
}

/// Estado de la tierra de la parcela.
class SoilHealth extends Equatable {
  /// Crea el estado de la tierra.
  const SoilHealth({required this.condition, required this.findings});

  /// Estado estimado.
  final SoilCondition condition;

  /// Hallazgos que explican el estado (contenido del backend, B11).
  final List<String> findings;

  @override
  List<Object?> get props => [condition, findings];
}

/// Todo lo que el backend entrega para planificar la campaña.
class CropPlanningData extends Equatable {
  /// Crea el paquete de datos.
  const CropPlanningData({
    required this.options,
    required this.currentPractice,
    required this.soilHealth,
    required this.scenarioNotes,
    required this.riskMonths,
    required this.irrigationSource,
  });

  /// Rotaciones que se pueden recomendar, en el orden del backend.
  final List<RotationOption> options;

  /// Lo que siembra hoy, para comparar.
  final CurrentPractice currentPractice;

  /// Estado actual de la tierra.
  final SoilHealth soilHealth;

  /// Introducción por escenario ("Con El Niño llueve más; ").
  final Map<ClimateScenario, String> scenarioNotes;

  /// Meses con riesgo climático para la cosecha, por escenario.
  final Map<ClimateScenario, List<DateTime>> riskMonths;

  /// Fuente de agua de riego (p. ej., "Poechos").
  final String irrigationSource;

  @override
  List<Object?> get props => [
    options,
    currentPractice,
    soilHealth,
    scenarioNotes,
    riskMonths,
    irrigationSource,
  ];
}

/// Respuesta a "Cuéntanos qué sembraste".
class PlantingFeedback extends Equatable {
  /// Crea la respuesta.
  const PlantingFeedback({
    required this.rotationId,
    required this.followedRecommendation,
  });

  /// Rotación que se le recomendó.
  final String rotationId;

  /// `false` = "Sembré otra cosa". Qué sembró exactamente aún no está
  /// definido (decisión B6).
  final bool followedRecommendation;

  @override
  List<Object?> get props => [rotationId, followedRecommendation];
}

/// Fuente de datos de planificación de cultivos.
abstract interface class CropPlanningRepository {
  /// Devuelve opciones, práctica actual y estado del suelo.
  Future<CropPlanningData> getPlanningData();

  /// Registra qué sembró el agricultor.
  Future<void> submitPlantingFeedback(PlantingFeedback feedback);
}
