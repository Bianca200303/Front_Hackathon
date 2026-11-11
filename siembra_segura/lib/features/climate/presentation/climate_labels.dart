import 'package:flutter/material.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/theme/app_colors.dart';
import 'package:siembra_segura/core/utils/formatters.dart';
import 'package:siembra_segura/features/climate/domain/climate_overview.dart';

/// Textos e icono del estado del tiempo.
extension WeatherConditionLabels on WeatherCondition {
  /// Nombre del estado ("Lluvia fuerte").
  String label(AppLocalizations l10n) => switch (this) {
    WeatherCondition.sunny => l10n.weatherSunny,
    WeatherCondition.cloudy => l10n.weatherCloudy,
    WeatherCondition.rain => l10n.weatherRain,
    WeatherCondition.moderateRain => l10n.weatherModerateRain,
    WeatherCondition.heavyRain => l10n.weatherHeavyRain,
  };

  /// Etiqueta corta para la grilla semanal.
  String shortLabel(AppLocalizations l10n) => switch (this) {
    WeatherCondition.moderateRain => l10n.weatherRain,
    WeatherCondition.heavyRain => l10n.weatherHeavyRainShort,
    _ => label(l10n),
  };

  /// Icono del estado.
  IconData get icon => switch (this) {
    WeatherCondition.sunny => Icons.wb_sunny_outlined,
    WeatherCondition.cloudy => Icons.cloud_outlined,
    WeatherCondition.rain || WeatherCondition.moderateRain => Icons.grain,
    WeatherCondition.heavyRain => Icons.thunderstorm_outlined,
  };
}

/// Textos y color de una anomalía climática.
extension ClimateAnomalyLabels on ClimateAnomaly {
  /// Nombre del indicador ("Lluvia").
  String metricLabel(AppLocalizations l10n) => switch (metric) {
    ClimateMetric.rainfall => l10n.anomalyRainfall,
    ClimateMetric.temperature => l10n.anomalyTemperature,
    ClimateMetric.soilMoisture => l10n.anomalySoilMoisture,
  };

  /// Cómo está respecto a lo normal ("3 veces más").
  String statusLabel(AppLocalizations l10n) => switch (comparison) {
    TimesNormal(:final factor) when factor > 1 => l10n.anomalyTimesMore(
      AppFormatters.decimal(factor),
    ),
    TimesNormal(:final factor) when factor < 1 => l10n.anomalyTimesLess(
      AppFormatters.decimal(1 / factor),
    ),
    DegreesFromNormal(:final delta) when delta > 0 => l10n.anomalyDegreesMore(
      AppFormatters.decimal(delta),
    ),
    DegreesFromNormal(:final delta) when delta < 0 => l10n.anomalyDegreesLess(
      AppFormatters.decimal(-delta),
    ),
    MoistureCategory(:final level) => switch (level) {
      SoilMoistureLevel.veryWet => l10n.moistureVeryWet,
      SoilMoistureLevel.wet => l10n.moistureWet,
      SoilMoistureLevel.normal => l10n.moistureNormal,
      SoilMoistureLevel.dry => l10n.moistureDry,
    },
    _ => l10n.anomalyAsNormal,
  };

  /// Color de la barra: calor en ámbar; lluvia y humedad en azul.
  Color get barColor =>
      metric == ClimateMetric.temperature ? AppColors.heat : AppColors.water;

  /// Color según si está por encima, normal o por debajo.
  Tone get statusTone {
    if (comparison.isNormal) return AppColors.normalTone;
    return metric == ClimateMetric.temperature
        ? AppColors.heatTone
        : AppColors.waterTone;
  }
}
