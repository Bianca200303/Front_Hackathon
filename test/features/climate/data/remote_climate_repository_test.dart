import 'package:flutter_test/flutter_test.dart';
import 'package:siembra_segura/core/error/app_exception.dart';
import 'package:siembra_segura/core/network/api_client.dart';
import 'package:siembra_segura/features/climate/data/remote_climate_repository.dart';
import 'package:siembra_segura/features/climate/domain/climate_overview.dart';
import 'package:siembra_segura/shared/domain/farm_location.dart';

class _FakeApiClient implements ApiClient {
  _FakeApiClient(this.response);

  final Object? response;
  String? path;
  Map<String, String>? query;

  @override
  Future<Object?> get(String path, {Map<String, String>? query}) async {
    this.path = path;
    this.query = query;
    return response;
  }

  @override
  Future<Object?> post(String path, {Object? body}) =>
      throw UnimplementedError();
}

const _location = FarmLocation(
  valleyName: 'Medio Piura',
  latitude: -5.19,
  longitude: -80.63,
);

Map<String, Object?> _overviewJson() => {
  'today': {
    'date': '2026-11-08',
    'condition': 'moderate_rain',
    'rain_probability': 0.7,
    'rain_mm': 12,
    'temperature_c': 31.0,
  },
  'week': [
    {'date': '2026-11-08', 'condition': 'moderate_rain', 'rain_mm': 12.0},
    {'date': '2026-11-11', 'condition': 'heavy_rain', 'rain_mm': 40.0},
  ],
  'advice': 'no siembres ni abones hasta el jueves.',
  'anomalies': [
    {
      'metric': 'rainfall',
      'observed_level': 0.9,
      'normal_level': 0.3,
      'comparison': {'type': 'times_normal', 'factor': 3.0},
    },
    {
      'metric': 'temperature',
      'observed_level': 0.62,
      'normal_level': 0.5,
      'comparison': {'type': 'degrees_from_normal', 'delta': 2},
    },
    {
      'metric': 'soil_moisture',
      'observed_level': 0.85,
      'normal_level': 0.45,
      'comparison': {'type': 'moisture_category', 'level': 'very_wet'},
    },
  ],
  'sources': ['open_meteo', 'nasa_power'],
};

void main() {
  test('pide el clima de la parcela y lo convierte al dominio', () async {
    final api = _FakeApiClient(_overviewJson());
    final repository = RemoteClimateRepository(
      apiClient: api,
      location: _location,
    );

    final overview = await repository.getOverview();

    expect(api.path, RemoteClimateRepository.path);
    expect(api.query, {'lat': '-5.19', 'lon': '-80.63'});
    expect(
      overview,
      ClimateOverview(
        valleyName: 'Medio Piura',
        today: TodayWeather(
          date: DateTime(2026, 11, 8),
          condition: WeatherCondition.moderateRain,
          rainProbability: 0.7,
          rainMm: 12,
          temperatureC: 31,
        ),
        week: [
          DailyForecast(
            date: DateTime(2026, 11, 8),
            condition: WeatherCondition.moderateRain,
            rainMm: 12,
          ),
          DailyForecast(
            date: DateTime(2026, 11, 11),
            condition: WeatherCondition.heavyRain,
            rainMm: 40,
          ),
        ],
        advice: 'no siembres ni abones hasta el jueves.',
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
      ),
    );
  });

  test('una respuesta con otro formato lanza UnexpectedException', () async {
    final json = _overviewJson()..['week'] = 'no es una lista';
    final repository = RemoteClimateRepository(
      apiClient: _FakeApiClient(json),
      location: _location,
    );

    await expectLater(
      repository.getOverview(),
      throwsA(isA<UnexpectedException>()),
    );
  });

  test('un estado del tiempo desconocido lanza UnexpectedException', () async {
    final json = _overviewJson()
      ..['today'] = {
        'date': '2026-11-08',
        'condition': 'snow',
        'rain_probability': 0,
        'rain_mm': 0,
        'temperature_c': 20,
      };
    final repository = RemoteClimateRepository(
      apiClient: _FakeApiClient(json),
      location: _location,
    );

    await expectLater(
      repository.getOverview(),
      throwsA(isA<UnexpectedException>()),
    );
  });
}
