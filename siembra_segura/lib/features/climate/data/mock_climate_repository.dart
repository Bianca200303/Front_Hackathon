import 'package:siembra_segura/core/utils/clock.dart';
import 'package:siembra_segura/core/utils/formatters.dart';
import 'package:siembra_segura/features/climate/domain/climate_overview.dart';

/// Datos de ejemplo de la referencia (mvp.html), con fechas relativas a hoy
/// para que "Hoy" y los días de la semana sean coherentes.
class MockClimateRepository implements ClimateRepository {
  /// Crea el repositorio; las fechas son relativas a [clock].
  const MockClimateRepository({
    required this.clock,
    this.latency = Duration.zero,
  });

  /// Hora actual, para fechar el pronóstico de ejemplo.
  final Clock clock;

  /// Espera simulada antes de responder.
  final Duration latency;

  static const _week = [
    (WeatherCondition.rain, 12.0),
    (WeatherCondition.cloudy, 0.0),
    (WeatherCondition.rain, 8.0),
    (WeatherCondition.heavyRain, 40.0),
    (WeatherCondition.cloudy, 2.0),
    (WeatherCondition.sunny, 0.0),
    (WeatherCondition.sunny, 0.0),
  ];

  @override
  Future<ClimateOverview> getOverview() async {
    await Future<void>.delayed(latency);
    final now = clock();
    final today = DateTime(now.year, now.month, now.day);
    final dayAfterStorm = today.add(const Duration(days: 4));

    return ClimateOverview(
      valleyName: 'Medio Piura',
      today: TodayWeather(
        date: today,
        condition: WeatherCondition.moderateRain,
        rainProbability: 0.7,
        rainMm: 12,
        temperatureC: 31,
      ),
      week: [
        for (final (index, (condition, rain)) in _week.indexed)
          DailyForecast(
            date: today.add(Duration(days: index)),
            condition: condition,
            rainMm: rain,
          ),
      ],
      advice:
          'no siembres ni abones hasta el '
          '${AppFormatters.weekday(dayAfterStorm)}. '
          'Tu suelo ya está muy húmedo.',
      anomalies: const [
        ClimateAnomaly(
          metric: ClimateMetric.rainfall,
          observedLevel: 0.9,
          normalLevel: 0.3,
          comparison: TimesNormal(3),
        ),
        ClimateAnomaly(
          metric: ClimateMetric.temperature,
          observedLevel: 0.62,
          normalLevel: 0.5,
          comparison: DegreesFromNormal(2),
        ),
        ClimateAnomaly(
          metric: ClimateMetric.soilMoisture,
          observedLevel: 0.85,
          normalLevel: 0.45,
          comparison: MoistureCategory(SoilMoistureLevel.veryWet),
        ),
      ],
    );
  }
}
