import 'package:flutter_test/flutter_test.dart';
import 'package:siembra_segura/core/error/app_exception.dart';
import 'package:siembra_segura/core/network/api_client.dart';
import 'package:siembra_segura/features/crop_planning/data/remote_crop_planning_repository.dart';
import 'package:siembra_segura/features/crop_planning/domain/crop_planning_models.dart';
import 'package:siembra_segura/shared/data/pilot_farm_location.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';

class _FakeApiClient implements ApiClient {
  _FakeApiClient(this.response);

  final Object? response;
  String? path;
  Object? body;

  @override
  Future<Object?> get(String path, {Map<String, String>? query}) =>
      throw UnimplementedError();

  @override
  Future<Object?> post(String path, {Object? body}) async {
    this.path = path;
    this.body = body;
    return response;
  }
}

final _query = CropPlanningQuery(
  location: pilotFarmLocation,
  areaHectares: 2,
  plantingDate: DateTime(2026, 12, 15),
  consecutiveCampaigns: 3,
  lastCropId: 'rice',
);

Map<String, Object?> _crop(
  String id,
  String name, {
  required int months,
  required String impact,
  required String water,
  bool fixesNitrogen = false,
}) => {
  'id': id,
  'name': name,
  'cycle_months': months,
  'soil_impact': impact,
  'water_need': water,
  'water_index': months * 0.8,
  'fixes_nitrogen': fixesNitrogen,
};

Map<String, Object?> _scenarioResult({
  required double water,
  required String risk,
  List<String> riskMonths = const [],
}) => {
  'irrigation_m3': water,
  'irrigation_m3_per_ha': water / 2,
  'risk_months': riskMonths,
  'risk_month_count': riskMonths.length,
  'climate_risk': risk,
  'monthly': const [],
};

Map<String, Object?> _factsheet() => {
  'rationale': 'El frejol le devuelve fuerza a tu tierra.',
  'evidence': 'El frejol fija nitrógeno.',
  'benefits': 'Usa menos agua.',
  'unknowns': 'No hay análisis de suelo.',
  'risks': 'Confirma tu turno de riego.',
};

Map<String, Object?> _recommendationJson() => {
  'area_ha': 2.0,
  'irrigation_source': 'Poechos',
  'crops': [
    _crop('rice', 'Arroz', months: 5, impact: 'degrades', water: 'high'),
    _crop('maize', 'Maíz', months: 4, impact: 'neutral', water: 'medium'),
    _crop(
      'bean',
      'Frejol',
      months: 3,
      impact: 'improves_a_lot',
      water: 'low',
      fixesNitrogen: true,
    ),
  ],
  'scenario_notes': {
    'heavy_rains': 'Con lluvias fuertes, ',
    'normal': 'En un año normal, ',
    'dry': 'En un año seco, ',
  },
  'risk_months': {
    'heavy_rains': ['2027-02-01', '2027-03-01'],
    'normal': <String>[],
    'dry': <String>[],
  },
  'soil_health': {
    'condition': 'tired',
    'findings': ['Lleva 3 campañas seguidas de arroz.'],
  },
  'current_practice': {
    'crop_ids': ['rice', 'rice'],
    'consecutive_campaigns': 3,
    'cycle_months': 10,
    'soil_in_two_years': 'very_tired',
    'factsheet': _factsheet(),
    'repeat_warnings': {
      'heavy_rains': 'Puede inundarse.',
      'normal': 'Gastas mucha agua.',
      'dry': 'Puede faltarte agua.',
    },
    'scenarios': {
      'heavy_rains': _scenarioResult(
        water: 20300,
        risk: 'high',
        riskMonths: const ['2027-02-01', '2027-03-01'],
      ),
      'normal': _scenarioResult(water: 29000, risk: 'low'),
      'dry': _scenarioResult(water: 34800, risk: 'low'),
    },
  },
  'options': [
    {
      'id': 'r1',
      'crop_ids': ['maize', 'bean'],
      'cycle_months': 7,
      'soil_impact': 'improves_a_lot',
      'soil_impact_score': 2,
      'soil_in_two_years': 'good',
      'factsheet': _factsheet(),
      'excluded_by': ['low-water'],
      'warnings': ['Frijol se sembraría en marzo.'],
      'calendar': {
        'planting_date': '2026-12-15',
        'decision_deadline': '2026-12-15',
        'timeline_start': '2026-12-01',
        'timeline_months': 7,
        'periods': [
          {'crop_id': 'maize', 'start': '2026-12-01', 'month_count': 4},
          {'crop_id': 'bean', 'start': '2027-04-01', 'month_count': 3},
        ],
        'instructions': 'Siembra el maíz en la primera quincena.',
      },
      'long_term_plan': [
        {
          'crop_id': 'maize',
          'start': '2026-12-01',
          'end': '2027-03-01',
          'soil_after': 'tired',
        },
      ],
      'scenarios': {
        'heavy_rains': _scenarioResult(
          water: 6928,
          risk: 'high',
          riskMonths: const ['2027-02-01', '2027-03-01'],
        ),
        'normal': _scenarioResult(water: 12786, risk: 'low'),
        'dry': _scenarioResult(water: 15442, risk: 'medium'),
      },
    },
  ],
  'ranking': {
    'save-water': {
      'heavy_rains': ['r1'],
      'normal': ['r1'],
      'dry': ['r1'],
    },
  },
  'recent_rain': {
    'start': '2026-09-01',
    'end': '2026-09-30',
    'observed_days': 30,
    'total_mm': 4.2,
    'scenario_totals': {'heavy_rains': 61.0, 'normal': 9.8, 'dry': 2.1},
    'closest_scenario': 'dry',
    'finding': 'Llovieron 4.2 mm: la lluvia va como en un año seco.',
    'source': 'gpm_imerg',
  },
  'water_availability': {
    'level': 'low',
    'window_start': '2024-05-01',
    'window_end': '2024-10-31',
    'rain_mm': 2.0,
    'rain_normal_mm': 17.8,
    'rain_percentile': 0.0,
    'root_wetness': 0.3,
    'root_wetness_normal': 0.4,
    'root_wetness_percentile': 10.0,
    'reference_years': [2014, 2023],
    'finding': 'En tu zona llovió menos de la mitad de lo normal estos meses.',
    'source': 'nasa_power',
  },
  'irrigation_water': {
    'level': 'medium',
    'season_start': '2023-12-01',
    'season_end': '2024-04-30',
    'rain_mm': 301.5,
    'rain_normal_mm': 340.4,
    'percent_vs_normal': -11.4,
    'rain_percentile': 40.0,
    'reference_seasons': [2014, 2023],
    'points': <Object?>[],
    'finding':
        'En los cerros donde nace tu río llovió 11 % menos de lo normal.',
    'note': 'Es una aproximación con la lluvia de la cuenca alta.',
    'source': 'nasa_power',
  },
};

void main() {
  test('pide la recomendación con lo que ingresó el agricultor', () async {
    final api = _FakeApiClient(_recommendationJson());
    final repository = RemoteCropPlanningRepository(apiClient: api);

    await repository.getPlanningData(_query);

    expect(api.path, RemoteCropPlanningRepository.path);
    expect(api.body, {
      'lat': -4.865,
      'lon': -80.72,
      'area_ha': 2.0,
      'planting_date': '2026-12-15',
      'consecutive_campaigns': 3,
      'last_crop_id': 'rice',
    });
  });

  test('manda la textura que reconoció el agricultor', () async {
    final api = _FakeApiClient(_recommendationJson());
    final repository = RemoteCropPlanningRepository(apiClient: api);

    await repository.getPlanningData(
      CropPlanningQuery(
        location: pilotFarmLocation,
        areaHectares: 1,
        plantingDate: DateTime(2026, 12, 15),
        consecutiveCampaigns: 1,
        reportedSoilTexture: SoilTexture.clayey,
      ),
    );

    expect(
      (api.body! as Map<String, Object?>)['reported_soil_texture'],
      'clayey',
    );
  });

  test('sin textura elegida no se manda el campo', () async {
    final api = _FakeApiClient(_recommendationJson());
    final repository = RemoteCropPlanningRepository(apiClient: api);

    await repository.getPlanningData(_query);

    expect(
      (api.body! as Map<String, Object?>).containsKey('reported_soil_texture'),
      isFalse,
    );
  });

  test('manda la rotación que armó el agricultor', () async {
    final api = _FakeApiClient(_recommendationJson());
    final repository = RemoteCropPlanningRepository(apiClient: api);

    await repository.getPlanningData(
      CropPlanningQuery(
        location: pilotFarmLocation,
        areaHectares: 1,
        plantingDate: DateTime(2026, 12, 15),
        consecutiveCampaigns: 1,
        customRotation: const ['rice', 'bean', 'maize'],
      ),
    );

    expect((api.body! as Map<String, Object?>)['custom_rotation'], [
      'rice',
      'bean',
      'maize',
    ]);
  });

  test('sin cultivo elegido deja que lo decida el servidor', () async {
    final api = _FakeApiClient(_recommendationJson());
    final repository = RemoteCropPlanningRepository(apiClient: api);

    await repository.getPlanningData(
      CropPlanningQuery(
        location: pilotFarmLocation,
        areaHectares: 1,
        plantingDate: DateTime(2026, 12, 15),
        consecutiveCampaigns: 1,
      ),
    );

    expect(
      (api.body! as Map<String, Object?>).containsKey('last_crop_id'),
      isFalse,
    );
  });

  test('convierte la respuesta al dominio', () async {
    final repository = RemoteCropPlanningRepository(
      apiClient: _FakeApiClient(_recommendationJson()),
    );

    final data = await repository.getPlanningData(_query);

    expect(data.areaHectares, 2);
    expect(data.irrigationSource, 'Poechos');
    expect(data.availableCrops.map((crop) => crop.id), [
      'rice',
      'maize',
      'bean',
    ]);
    expect(data.soilHealth.condition, SoilCondition.tired);
    expect(
      data.availableCrops.firstWhere((crop) => crop.id == 'bean'),
      const Crop(
        id: 'bean',
        name: 'Frejol',
        cycleMonths: 3,
        waterNeed: CropWaterNeed.low,
        fixesNitrogen: true,
      ),
    );
    expect(
      data.measuredRainNote,
      'Llovieron 4.2 mm: la lluvia va como en un año seco.',
    );
    expect(data.riskMonths[ClimateScenario.heavyRains], [
      DateTime(2027, 2),
      DateTime(2027, 3),
    ]);
    expect(data.scenarioNotes[ClimateScenario.normal], 'En un año normal, ');

    final current = data.currentPractice;
    expect(current.crops.map((crop) => crop.name), ['Arroz', 'Arroz']);
    expect(current.resultFor(ClimateScenario.normal).waterUseM3, 29000);
    expect(current.soilInTwoYears, SoilCondition.veryTired);
    expect(current.consecutiveCampaigns, 3);

    final option = data.options.single;
    expect(option.id, 'r1');
    expect(option.crops.map((crop) => crop.name), ['Maíz', 'Frejol']);
    expect(option.soilImpact, SoilImpact.improvesALot);
    expect(option.soilInTwoYears, SoilCondition.good);
    expect(option.excludedBy, {'low-water'});
    expect(option.warnings, ['Frijol se sembraría en marzo.']);
    expect(option.factsheet.rationale, startsWith('El frejol'));
    expect(
      option.resultFor(ClimateScenario.dry).climateRisk,
      ClimateRisk.medium,
    );
    expect(
      option.resultFor(ClimateScenario.heavyRains).riskMonths,
      hasLength(2),
    );
    expect(option.schedule.timelineStart, DateTime(2026, 12));
    expect(option.schedule.timelineMonths, 7);
    expect(option.schedule.periods.first.crop.name, 'Maíz');
    expect(option.schedule.periods.first.monthCount, 4);
    expect(option.longTermPlan.single.soilAfter, SoilCondition.tired);
  });

  test('sin lluvia medida todavía, la nota viene vacía', () async {
    final json = _recommendationJson()..['recent_rain'] = null;
    final repository = RemoteCropPlanningRepository(
      apiClient: _FakeApiClient(json),
    );

    final data = await repository.getPlanningData(_query);

    expect(data.measuredRainNote, isNull);
  });

  test('trae el semáforo de agua, o nada si el backend no lo tiene', () async {
    final data = await RemoteCropPlanningRepository(
      apiClient: _FakeApiClient(_recommendationJson()),
    ).getPlanningData(_query);

    expect(
      data.waterAvailability,
      WaterAvailability(
        level: WaterLevel.low,
        finding:
            'En tu zona llovió menos de la mitad de lo normal estos meses.',
        windowStart: DateTime(2024, 5),
        windowEnd: DateTime(2024, 10, 31),
      ),
    );

    final withoutWater = await RemoteCropPlanningRepository(
      apiClient: _FakeApiClient(
        _recommendationJson()..['water_availability'] = null,
      ),
    ).getPlanningData(_query);
    expect(withoutWater.waterAvailability, isNull);

    expect(
      data.irrigationWater,
      IrrigationWater(
        level: WaterLevel.medium,
        finding:
            'En los cerros donde nace tu río llovió 11 % menos de lo normal.',
        note: 'Es una aproximación con la lluvia de la cuenca alta.',
        seasonStart: DateTime(2023, 12),
        seasonEnd: DateTime(2024, 4, 30),
      ),
    );
  });

  test('trae el orden de cada prioridad y escenario', () async {
    final repository = RemoteCropPlanningRepository(
      apiClient: _FakeApiClient(_recommendationJson()),
    );

    final data = await repository.getPlanningData(_query);

    expect(data.orderFor('save-water', ClimateScenario.normal), ['r1']);
    expect(data.orderFor('restore-soil', ClimateScenario.normal), isEmpty);
  });

  test('un cultivo que no viene en la respuesta lanza UnexpectedException', () {
    final json = _recommendationJson()..['crops'] = const [];
    final repository = RemoteCropPlanningRepository(
      apiClient: _FakeApiClient(json),
    );

    expect(
      repository.getPlanningData(_query),
      throwsA(isA<UnexpectedException>()),
    );
  });

  test('un nivel de riesgo desconocido lanza UnexpectedException', () {
    final json = _recommendationJson();
    final options = json['options']! as List<Object?>;
    final scenarios =
        (options.single! as Map<String, Object?>)['scenarios']!
            as Map<String, Object?>;
    scenarios['normal'] = _scenarioResult(water: 1, risk: 'catastrófico');
    final repository = RemoteCropPlanningRepository(
      apiClient: _FakeApiClient(json),
    );

    expect(
      repository.getPlanningData(_query),
      throwsA(isA<UnexpectedException>()),
    );
  });

  test('la respuesta de "qué sembré" se guarda hasta que exista B6', () async {
    final repository = RemoteCropPlanningRepository(
      apiClient: _FakeApiClient(_recommendationJson()),
    );

    await repository.submitPlantingFeedback(
      const PlantingFeedback(rotationId: 'r1', followedRecommendation: true),
    );

    expect(repository.submittedFeedback, hasLength(1));
  });
}
