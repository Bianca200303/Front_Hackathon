import 'package:flutter_test/flutter_test.dart';
import 'package:siembra_segura/core/l10n/app_localizations_es.dart';
import 'package:siembra_segura/core/theme/app_palette.dart';
import 'package:siembra_segura/features/climate/domain/climate_overview.dart';
import 'package:siembra_segura/features/climate/presentation/climate_labels.dart';

void main() {
  final l10n = AppLocalizationsEs();

  ClimateAnomaly anomaly(ClimateMetric metric, AnomalyComparison comparison) =>
      ClimateAnomaly(
        metric: metric,
        observedLevel: 0.5,
        normalLevel: 0.5,
        comparison: comparison,
      );

  test('describe cada tipo de comparación', () {
    expect(
      anomaly(ClimateMetric.rainfall, const TimesNormal(3)).statusLabel(l10n),
      '3 veces más',
    );
    expect(
      anomaly(ClimateMetric.rainfall, const TimesNormal(0.5)).statusLabel(l10n),
      '2 veces menos',
    );
    expect(
      anomaly(
        ClimateMetric.temperature,
        const DegreesFromNormal(2),
      ).statusLabel(l10n),
      '2 °C más',
    );
    expect(
      anomaly(
        ClimateMetric.temperature,
        const DegreesFromNormal(-1.5),
      ).statusLabel(l10n),
      '1.5 °C menos',
    );
    expect(
      anomaly(
        ClimateMetric.soilMoisture,
        const MoistureCategory(SoilMoistureLevel.veryWet),
      ).statusLabel(l10n),
      'Muy húmedo',
    );
    expect(
      anomaly(ClimateMetric.rainfall, const TimesNormal(1)).statusLabel(l10n),
      'Como lo normal',
    );
  });

  test('elige colores según el indicador', () {
    final heat = anomaly(ClimateMetric.temperature, const DegreesFromNormal(2));
    final normal = anomaly(ClimateMetric.rainfall, const TimesNormal(1));

    const colors = AppPalette.light;
    expect(heat.barColor(colors), colors.heat);
    expect(heat.statusTone(colors), colors.heatTone);
    expect(normal.statusTone(colors), colors.normalTone);
    // En oscuro cambian los colores, no la regla.
    expect(heat.barColor(AppPalette.dark), AppPalette.dark.heat);
  });

  test('ClimateOverview encuentra el primer día de lluvia fuerte', () {
    final overview = ClimateOverview(
      valleyName: 'Valle',
      today: TodayWeather(
        date: DateTime(2026, 11, 8),
        condition: WeatherCondition.sunny,
        rainProbability: 0,
        rainMm: 0,
        temperatureC: 30,
      ),
      week: [
        DailyForecast(
          date: DateTime(2026, 11, 8),
          condition: WeatherCondition.rain,
          rainMm: 5,
        ),
        DailyForecast(
          date: DateTime(2026, 11, 9),
          condition: WeatherCondition.heavyRain,
          rainMm: 40,
        ),
      ],
      advice: '',
      anomalies: const [],
    );

    expect(overview.firstHeavyRainDay?.date, DateTime(2026, 11, 9));
  });
}
