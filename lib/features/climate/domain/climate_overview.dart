import 'package:equatable/equatable.dart';

/// Estado del tiempo de un día, de mejor a peor para la siembra.
enum WeatherCondition {
  /// Soleado.
  sunny,

  /// Nublado.
  cloudy,

  /// Lluvia ligera.
  rain,

  /// Lluvia moderada.
  moderateRain,

  /// Lluvia fuerte: se marca como alerta en la semana.
  heavyRain,
}

/// Indicador que se compara con un año normal.
enum ClimateMetric {
  /// Lluvia acumulada.
  rainfall,

  /// Temperatura.
  temperature,

  /// Humedad de la tierra.
  soilMoisture,
}

/// Categoría de humedad de la tierra.
enum SoilMoistureLevel {
  /// Seca.
  dry,

  /// Normal.
  normal,

  /// Húmeda.
  wet,

  /// Muy húmeda.
  veryWet,
}

/// El tiempo de hoy en la parcela.
class TodayWeather extends Equatable {
  /// Crea el pronóstico de hoy.
  const TodayWeather({
    required this.date,
    required this.condition,
    required this.rainProbability,
    required this.rainMm,
    required this.temperatureC,
  });

  /// Fecha del pronóstico.
  final DateTime date;

  /// Estado del tiempo.
  final WeatherCondition condition;

  /// Entre 0 y 1.
  final double rainProbability;

  /// Lluvia esperada, en mm.
  final double rainMm;

  /// Temperatura, en °C.
  final double temperatureC;

  @override
  List<Object?> get props => [
    date,
    condition,
    rainProbability,
    rainMm,
    temperatureC,
  ];
}

/// Pronóstico de un día de la semana.
class DailyForecast extends Equatable {
  /// Crea el pronóstico de un día.
  const DailyForecast({
    required this.date,
    required this.condition,
    required this.rainMm,
  });

  /// Fecha del día.
  final DateTime date;

  /// Estado del tiempo.
  final WeatherCondition condition;

  /// Lluvia esperada, en mm.
  final double rainMm;

  /// `true` si se espera lluvia fuerte (día de alerta).
  bool get isHeavyRain => condition == WeatherCondition.heavyRain;

  /// `true` si se espera cualquier tipo de lluvia.
  bool get isRainy =>
      condition == WeatherCondition.rain ||
      condition == WeatherCondition.moderateRain;

  @override
  List<Object?> get props => [date, condition, rainMm];
}

/// Cómo se compara un indicador con lo normal para el mes.
sealed class AnomalyComparison extends Equatable {
  const AnomalyComparison();

  /// `true` si el indicador está por encima de lo normal.
  bool get isAboveNormal;

  /// `true` si el indicador está dentro de lo normal.
  bool get isNormal;
}

/// "3 veces más" lluvia que lo normal.
final class TimesNormal extends AnomalyComparison {
  /// Crea la comparación; [factor] debe ser positivo.
  const TimesNormal(this.factor) : assert(factor > 0);

  /// Cuántas veces lo normal (1 = normal).
  final double factor;

  @override
  bool get isAboveNormal => factor > 1;

  @override
  bool get isNormal => factor == 1;

  @override
  List<Object?> get props => [factor];
}

/// "2 °C más" que lo normal.
final class DegreesFromNormal extends AnomalyComparison {
  /// Crea la comparación en grados.
  const DegreesFromNormal(this.delta);

  /// Diferencia con lo normal, en °C (positivo = más calor).
  final double delta;

  @override
  bool get isAboveNormal => delta > 0;

  @override
  bool get isNormal => delta == 0;

  @override
  List<Object?> get props => [delta];
}

/// "Muy húmedo".
final class MoistureCategory extends AnomalyComparison {
  /// Crea la comparación por categoría.
  const MoistureCategory(this.level);

  /// Categoría de humedad actual.
  final SoilMoistureLevel level;

  @override
  bool get isAboveNormal =>
      level == SoilMoistureLevel.wet || level == SoilMoistureLevel.veryWet;

  @override
  bool get isNormal => level == SoilMoistureLevel.normal;

  @override
  List<Object?> get props => [level];
}

/// Un indicador climático comparado con un año normal.
class ClimateAnomaly extends Equatable {
  /// Crea la anomalía.
  const ClimateAnomaly({
    required this.metric,
    required this.observedLevel,
    required this.normalLevel,
    required this.comparison,
  }) : assert(observedLevel >= 0 && observedLevel <= 1),
       assert(normalLevel >= 0 && normalLevel <= 1);

  /// Indicador que se compara.
  final ClimateMetric metric;

  /// Posición del valor observado en la barra (0 a 1).
  final double observedLevel;

  /// Posición de lo normal en la barra (0 a 1).
  final double normalLevel;

  /// Cómo se compara con lo normal.
  final AnomalyComparison comparison;

  @override
  List<Object?> get props => [metric, observedLevel, normalLevel, comparison];
}

/// Todo lo que muestra la pantalla Clima.
class ClimateOverview extends Equatable {
  /// Crea el resumen.
  const ClimateOverview({
    required this.valleyName,
    required this.today,
    required this.week,
    required this.advice,
    required this.anomalies,
  });

  /// Nombre del valle (p. ej., "Valle del Chira").
  final String valleyName;

  /// El tiempo de hoy.
  final TodayWeather today;

  /// Pronóstico de los próximos días, en orden.
  final List<DailyForecast> week;

  /// Recomendación práctica para estos días (contenido del backend, B11).
  final String advice;

  /// Indicadores comparados con un año normal.
  final List<ClimateAnomaly> anomalies;

  /// Primer día de la semana con lluvia fuerte, si hay alguno.
  DailyForecast? get firstHeavyRainDay {
    for (final day in week) {
      if (day.isHeavyRain) return day;
    }
    return null;
  }

  @override
  List<Object?> get props => [valleyName, today, week, advice, anomalies];
}

/// Fuente de datos del clima.
abstract interface class ClimateRepository {
  /// Devuelve el resumen climático de la parcela.
  Future<ClimateOverview> getOverview();
}
