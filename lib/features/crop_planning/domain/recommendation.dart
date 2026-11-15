import 'package:equatable/equatable.dart';
import 'package:siembra_segura/features/crop_planning/domain/crop_planning_models.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';

/// Recomendación para un escenario y una prioridad concretos.
class Recommendation extends Equatable {
  /// Crea la recomendación.
  const Recommendation({
    required this.scenario,
    required this.priority,
    required this.rankedOptions,
    required this.data,
  });

  /// Escenario para el que se calculó.
  final ClimateScenario scenario;

  /// Prioridad con la que se ordenó.
  final CampaignPriority priority;

  /// Opciones permitidas, de mejor a peor según la prioridad.
  final List<RotationOption> rankedOptions;

  /// Datos de los que sale la recomendación.
  final CropPlanningData data;

  /// Es falso si las restricciones descartaron todas las opciones.
  bool get hasOptions => rankedOptions.isNotEmpty;

  /// La opción recomendada. Solo válida si [hasOptions].
  RotationOption get best => rankedOptions.first;

  /// Agua y riesgo de la opción recomendada en el escenario.
  RotationScenarioResult get bestResult => best.resultFor(scenario);

  /// Lo que el agricultor siembra hoy.
  CurrentPractice get currentPractice => data.currentPractice;

  /// Agua y riesgo de la práctica actual en el escenario.
  RotationScenarioResult get currentResult =>
      currentPractice.resultFor(scenario);

  /// Introducción del escenario para la explicación.
  String get scenarioNote => data.scenarioNotes[scenario] ?? '';

  /// Meses con riesgo climático en el escenario.
  List<DateTime> get riskMonths => data.riskMonths[scenario] ?? const [];

  @override
  List<Object?> get props => [scenario, priority, rankedOptions, data];
}
