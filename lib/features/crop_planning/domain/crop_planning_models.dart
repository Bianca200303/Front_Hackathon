import 'package:equatable/equatable.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';
import 'package:siembra_segura/shared/domain/farm_location.dart';

/// Agua de riego y riesgo de clima de una opción en un escenario.
class RotationScenarioResult extends Equatable {
  /// Crea el resultado del escenario.
  const RotationScenarioResult({
    required this.waterUseM3,
    required this.climateRisk,
    required this.riskMonths,
  });

  /// Agua de riego de todo el ciclo, en m³ para el área de la parcela.
  final int waterUseM3;

  /// Riesgo de clima de la opción en este escenario.
  final ClimateRisk climateRisk;

  /// Meses del calendario de la opción que caen en meses de riesgo.
  final List<DateTime> riskMonths;

  @override
  List<Object?> get props => [waterUseM3, climateRisk, riskMonths];
}

/// Cómo afecta una rotación a la tierra, de peor a mejor. El orden de los
/// valores es el que usa "recuperar mi tierra" para comparar.
enum SoilImpact {
  /// Cansa la tierra.
  degrades,

  /// No la cansa ni la mejora.
  neutral,

  /// Mejora la tierra.
  improves,

  /// Mejora mucho la tierra.
  improvesALot,
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

/// Nivel del semáforo de agua.
enum WaterLevel {
  /// Menos agua que en la mayoría de años: rojo.
  low,

  /// Como en un año común: ámbar.
  medium,

  /// Más agua que en la mayoría de años: verde.
  high,
}

/// Agua disponible en la zona de la chacra (NASA POWER): lluvia y humedad
/// de la tierra de los últimos meses frente a los mismos meses de los 10
/// años anteriores. Lo calcula el backend; con datos de ejemplo no hay.
class WaterAvailability extends Equatable {
  /// Crea el indicador.
  const WaterAvailability({
    required this.level,
    required this.finding,
    required this.windowStart,
    required this.windowEnd,
  });

  /// Nivel del semáforo.
  final WaterLevel level;

  /// Frase armada con las cifras reales (p. ej., "En tu zona llovió menos
  /// de la mitad de lo normal estos meses…").
  final String finding;

  /// Primer día de los meses observados.
  final DateTime windowStart;

  /// Último día de los meses observados.
  final DateTime windowEnd;

  @override
  List<Object?> get props => [level, finding, windowStart, windowEnd];
}

/// Agua que llega por riego, aproximada con la lluvia de la última
/// temporada en la cuenca alta del río (NASA POWER). No es el nivel real del
/// reservorio: [note] lo dice. Lo calcula el backend.
class IrrigationWater extends Equatable {
  /// Crea el indicador.
  const IrrigationWater({
    required this.level,
    required this.finding,
    required this.note,
    required this.seasonStart,
    required this.seasonEnd,
  });

  /// Nivel del semáforo.
  final WaterLevel level;

  /// Frase armada con las cifras ("En los cerros donde nace tu río…").
  final String finding;

  /// Aclaración de que es una aproximación con lluvia.
  final String note;

  /// Primer día de la temporada de lluvias observada.
  final DateTime seasonStart;

  /// Último día de la temporada de lluvias observada.
  final DateTime seasonEnd;

  @override
  List<Object?> get props => [level, finding, note, seasonStart, seasonEnd];
}

/// Rotación de cultivos que se puede recomendar.
class RotationOption extends Equatable {
  /// Crea una opción de rotación.
  const RotationOption({
    required this.id,
    required this.crops,
    required this.scenarios,
    required this.soilImpact,
    required this.soilInTwoYears,
    required this.factsheet,
    required this.schedule,
    required this.longTermPlan,
    this.excludedBy = const {},
    this.warnings = const [],
  });

  /// Identificador estable de la opción.
  final String id;

  /// Cultivos en orden de siembra (p. ej., maíz y después frejol).
  final List<Crop> crops;

  /// Agua y riesgo de clima por escenario.
  final Map<ClimateScenario, RotationScenarioResult> scenarios;

  /// Cómo afecta a la tierra.
  final SoilImpact soilImpact;

  /// Estado estimado de la tierra en dos años.
  final SoilCondition soilInTwoYears;

  /// Ficha explicativa.
  final OptionFactsheet factsheet;

  /// Calendario de siembra.
  final PlantingSchedule schedule;

  /// Plan de las próximas campañas.
  final List<CampaignStep> longTermPlan;

  /// Restricciones del agricultor que descartan esta opción.
  final Set<String> excludedBy;

  /// Reglas agronómicas que la secuencia rompe (misma familia seguida,
  /// siembra fuera de sus meses), en palabras del agricultor. Si hay
  /// alguna, el riesgo nunca es bajo.
  final List<String> warnings;

  /// Resultado en [scenario]. Lanza [StateError] si los datos no lo
  /// incluyen: es un error de contrato, no un caso esperado.
  RotationScenarioResult resultFor(ClimateScenario scenario) {
    final result = scenarios[scenario];
    if (result == null) {
      throw StateError('La opción $id no tiene resultados para $scenario.');
    }
    return result;
  }

  /// `true` si ninguna de las restricciones activas descarta la opción.
  bool isAllowedWith(Set<String> restrictionIds) =>
      excludedBy.intersection(restrictionIds).isEmpty;

  @override
  List<Object?> get props => [
    id,
    crops,
    scenarios,
    soilImpact,
    soilInTwoYears,
    factsheet,
    schedule,
    longTermPlan,
    excludedBy,
    warnings,
  ];
}

/// Lo que el agricultor siembra hoy, como punto de comparación.
class CurrentPractice extends Equatable {
  /// Crea la práctica actual.
  const CurrentPractice({
    required this.crops,
    required this.scenarios,
    required this.soilInTwoYears,
    required this.factsheet,
    required this.repeatWarnings,
    required this.consecutiveCampaigns,
    this.warnings = const [],
  });

  /// Cultivos de la rotación actual. Nunca vacío.
  final List<Crop> crops;

  /// Agua y riesgo de clima por escenario.
  final Map<ClimateScenario, RotationScenarioResult> scenarios;

  /// Estado estimado de la tierra en dos años si sigue igual.
  final SoilCondition soilInTwoYears;

  /// Ficha explicativa.
  final OptionFactsheet factsheet;

  /// Qué pasa si repite el cultivo, según el escenario.
  final Map<ClimateScenario, String> repeatWarnings;

  /// Campañas seguidas con el mismo cultivo.
  final int consecutiveCampaigns;

  /// Reglas agronómicas que rompe repetir el cultivo (ver
  /// [RotationOption.warnings]).
  final List<String> warnings;

  /// Cultivo principal (el primero de la rotación).
  Crop get mainCrop => crops.first;

  /// Resultado en [scenario]. Lanza [StateError] si los datos no lo
  /// incluyen: es un error de contrato, no un caso esperado.
  RotationScenarioResult resultFor(ClimateScenario scenario) {
    final result = scenarios[scenario];
    if (result == null) {
      throw StateError('La práctica actual no tiene datos para $scenario.');
    }
    return result;
  }

  @override
  List<Object?> get props => [
    crops,
    scenarios,
    soilInTwoYears,
    factsheet,
    repeatWarnings,
    consecutiveCampaigns,
    warnings,
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

/// Lo que el agricultor ingresa y condiciona el cálculo del servidor.
///
/// La prioridad y las restricciones **no** van aquí: el servidor manda el
/// orden de todas las prioridades y marca las opciones descartadas, así que
/// cambiarlas no obliga a pedir los datos otra vez.
class CropPlanningQuery extends Equatable {
  /// Crea la consulta.
  const CropPlanningQuery({
    required this.location,
    required this.areaHectares,
    required this.plantingDate,
    required this.consecutiveCampaigns,
    this.lastCropId,
    this.customRotation = const [],
    this.reportedSoilTexture,
  });

  /// Dónde está la parcela.
  final FarmLocation location;

  /// Superficie de la parcela, en hectáreas.
  final double areaHectares;

  /// Cuándo quiere sembrar el agricultor.
  final DateTime plantingDate;

  /// Campañas seguidas con el mismo cultivo.
  final int consecutiveCampaigns;

  /// Cultivo de la última campaña; `null` deja que lo decida la fuente.
  final String? lastCropId;

  /// Cultivos que armó el agricultor, en orden de siembra. Vacío = ninguno.
  final List<String> customRotation;

  /// Textura que el agricultor reconoció en su chacra; `null` deja que la
  /// estime el satélite.
  final SoilTexture? reportedSoilTexture;

  @override
  List<Object?> get props => [
    location,
    areaHectares,
    plantingDate,
    consecutiveCampaigns,
    lastCropId,
    customRotation,
    reportedSoilTexture,
  ];
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
    required this.areaHectares,
    this.availableCrops = const [],
    this.ranking = const {},
    this.measuredRainNote,
    this.waterAvailability,
    this.irrigationWater,
  });

  /// Id de la opción que arma el agricultor.
  static const customRotationId = 'custom';

  /// Rotaciones que se pueden recomendar, en el orden de la fuente.
  final List<RotationOption> options;

  /// Lo que siembra hoy, para comparar.
  final CurrentPractice currentPractice;

  /// Estado actual de la tierra.
  final SoilHealth soilHealth;

  /// Introducción por escenario ("En un año normal, ").
  final Map<ClimateScenario, String> scenarioNotes;

  /// Meses con riesgo climático para la cosecha, por escenario.
  final Map<ClimateScenario, List<DateTime>> riskMonths;

  /// Fuente de agua de riego (p. ej., "Poechos").
  final String irrigationSource;

  /// Hectáreas con las que se calculó el agua.
  final double areaHectares;

  /// Cultivos entre los que el agricultor puede armar su propia rotación.
  final List<Crop> availableCrops;

  /// Orden de las opciones por prioridad y escenario, si la fuente lo
  /// calcula. Vacío significa "ordena la app" (decisión 13).
  final Map<String, Map<ClimateScenario, List<String>>> ranking;

  /// Lluvia que el satélite ya midió sobre la chacra y a qué escenario se
  /// parece, en una frase. `null` si la fuente todavía no la tiene.
  final String? measuredRainNote;

  /// Semáforo de lluvia y tierra de la zona; `null` si la fuente no lo
  /// tiene.
  final WaterAvailability? waterAvailability;

  /// Semáforo del agua que llega por riego; `null` si la fuente no lo
  /// tiene.
  final IrrigationWater? irrigationWater;

  /// Orden que manda la fuente para [priorityId] en [scenario]; vacío si no
  /// lo manda.
  List<String> orderFor(String priorityId, ClimateScenario scenario) =>
      ranking[priorityId]?[scenario] ?? const [];

  /// La opción que armó el agricultor, si la fuente la devolvió.
  RotationOption? get customOption =>
      options.where((option) => option.id == customRotationId).firstOrNull;

  @override
  List<Object?> get props => [
    options,
    currentPractice,
    soilHealth,
    scenarioNotes,
    riskMonths,
    irrigationSource,
    areaHectares,
    availableCrops,
    ranking,
    measuredRainNote,
    waterAvailability,
    irrigationWater,
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
  /// Devuelve opciones, práctica actual y estado del suelo para [query].
  Future<CropPlanningData> getPlanningData(CropPlanningQuery query);

  /// Registra qué sembró el agricultor.
  Future<void> submitPlantingFeedback(PlantingFeedback feedback);
}
