import 'package:siembra_segura/core/error/app_exception.dart';
import 'package:siembra_segura/core/network/api_client.dart';
import 'package:siembra_segura/core/network/json_object.dart';
import 'package:siembra_segura/features/climate/domain/climate_overview.dart';
import 'package:siembra_segura/shared/domain/farm_location.dart';

/// Clima desde el backend (`GET /api/v1/app/climate-overview`): pronóstico
/// de Open-Meteo y comparación con lo normal según NASA POWER.
class RemoteClimateRepository implements ClimateRepository {
  /// Crea el repositorio para la parcela en [location].
  const RemoteClimateRepository({
    required this.apiClient,
    required this.location,
  });

  /// Cliente del backend.
  final ApiClient apiClient;

  /// Parcela de la que se pide el clima.
  final FarmLocation location;

  /// Ruta del recurso, relativa a `API_BASE_URL`.
  static const path = 'api/v1/app/climate-overview';

  @override
  Future<ClimateOverview> getOverview() async {
    final body = await apiClient.get(
      path,
      query: {
        'lat': location.latitude.toString(),
        'lon': location.longitude.toString(),
      },
    );
    try {
      return _overviewFromJson(JsonObject(body), location.valleyName);
    } on FormatException catch (error) {
      throw UnexpectedException(error);
    }
  }
}

const _conditions = {
  'sunny': WeatherCondition.sunny,
  'cloudy': WeatherCondition.cloudy,
  'rain': WeatherCondition.rain,
  'moderate_rain': WeatherCondition.moderateRain,
  'heavy_rain': WeatherCondition.heavyRain,
};

const _metrics = {
  'rainfall': ClimateMetric.rainfall,
  'temperature': ClimateMetric.temperature,
  'soil_moisture': ClimateMetric.soilMoisture,
};

const _moistureLevels = {
  'dry': SoilMoistureLevel.dry,
  'normal': SoilMoistureLevel.normal,
  'wet': SoilMoistureLevel.wet,
  'very_wet': SoilMoistureLevel.veryWet,
};

ClimateOverview _overviewFromJson(JsonObject json, String valleyName) {
  final today = json.object('today');
  return ClimateOverview(
    valleyName: valleyName,
    today: TodayWeather(
      date: today.date('date'),
      condition: today.oneOf('condition', _conditions),
      rainProbability: today.number('rain_probability'),
      rainMm: today.number('rain_mm'),
      temperatureC: today.number('temperature_c'),
    ),
    week: [
      for (final day in json.objects('week'))
        DailyForecast(
          date: day.date('date'),
          condition: day.oneOf('condition', _conditions),
          rainMm: day.number('rain_mm'),
        ),
    ],
    advice: json.string('advice'),
    anomalies: [
      for (final anomaly in json.objects('anomalies'))
        ClimateAnomaly(
          metric: anomaly.oneOf('metric', _metrics),
          observedLevel: anomaly.number('observed_level'),
          normalLevel: anomaly.number('normal_level'),
          comparison: _comparisonFromJson(anomaly.object('comparison')),
        ),
    ],
  );
}

AnomalyComparison _comparisonFromJson(JsonObject json) => switch (json.string(
  'type',
)) {
  'times_normal' => TimesNormal(json.number('factor')),
  'degrees_from_normal' => DegreesFromNormal(json.number('delta')),
  'moisture_category' => MoistureCategory(json.oneOf('level', _moistureLevels)),
  final other => throw FormatException('Comparación desconocida.', other),
};
