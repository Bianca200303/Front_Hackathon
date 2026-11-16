import 'package:siembra_segura/core/error/app_exception.dart';
import 'package:siembra_segura/core/network/api_client.dart';
import 'package:siembra_segura/core/network/json_object.dart';
import 'package:siembra_segura/features/crop_planning/domain/crop_planning_models.dart';
import 'package:siembra_segura/shared/data/soil_texture_ids.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';

/// Planificación desde el backend
/// (`POST /api/v1/app/recommendation`): agua de riego, riesgo de clima,
/// calendario y estado de la tierra calculados con NASA POWER para los tres
/// escenarios a la vez.
///
/// La prioridad y las restricciones no se envían: la respuesta trae el orden
/// de **todas** las prioridades y marca las opciones descartadas, así que
/// cambiarlas no obliga a pedir los datos otra vez.
class RemoteCropPlanningRepository implements CropPlanningRepository {
  /// Crea el repositorio.
  RemoteCropPlanningRepository({required this.apiClient});

  /// Cliente del backend.
  final ApiClient apiClient;

  /// Ruta del recurso, relativa a `API_BASE_URL`.
  static const path = 'api/v1/app/recommendation';

  /// Respuestas recibidas. El backend todavía no tiene dónde guardarlas
  /// (decisión B6), así que se quedan en memoria.
  final List<PlantingFeedback> submittedFeedback = [];

  @override
  Future<CropPlanningData> getPlanningData(CropPlanningQuery query) async {
    final body = await apiClient.post(
      path,
      body: {
        'lat': query.location.latitude,
        'lon': query.location.longitude,
        'area_ha': query.areaHectares,
        'planting_date': _isoDate(query.plantingDate),
        'consecutive_campaigns': query.consecutiveCampaigns,
        if (query.lastCropId != null) 'last_crop_id': query.lastCropId,
        if (query.customRotation.isNotEmpty)
          'custom_rotation': query.customRotation,
        if (query.reportedSoilTexture case final texture?)
          'reported_soil_texture': SoilTextureIds.of(texture),
      },
    );
    try {
      return _PlanningResponse(JsonObject(body)).toDomain();
    } on FormatException catch (error) {
      throw UnexpectedException(error);
    }
  }

  @override
  Future<void> submitPlantingFeedback(PlantingFeedback feedback) async {
    submittedFeedback.add(feedback);
  }
}

String _isoDate(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-'
    '${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';

const _scenarios = {
  'heavy_rains': ClimateScenario.heavyRains,
  'normal': ClimateScenario.normal,
  'dry': ClimateScenario.dry,
};

const _climateRisks = {
  'low': ClimateRisk.low,
  'medium': ClimateRisk.medium,
  'high': ClimateRisk.high,
};

const _soilImpacts = {
  'degrades': SoilImpact.degrades,
  'neutral': SoilImpact.neutral,
  'improves': SoilImpact.improves,
  'improves_a_lot': SoilImpact.improvesALot,
};

const _waterNeeds = {
  'low': CropWaterNeed.low,
  'medium': CropWaterNeed.medium,
  'high': CropWaterNeed.high,
};

const _waterLevels = {
  'low': WaterLevel.low,
  'medium': WaterLevel.medium,
  'high': WaterLevel.high,
};

const _soilConditions = {
  'very_tired': SoilCondition.veryTired,
  'tired': SoilCondition.tired,
  'regular': SoilCondition.regular,
  'good': SoilCondition.good,
};

/// Convierte la respuesta al dominio. Los `crop_ids` se resuelven con los
/// cultivos que trae la propia respuesta.
class _PlanningResponse {
  _PlanningResponse(this.json)
    : _crops = {
        for (final crop in json.objects('crops'))
          crop.string('id'): Crop(
            id: crop.string('id'),
            name: crop.string('name'),
            cycleMonths: crop.integer('cycle_months'),
            waterNeed: crop.oneOf('water_need', _waterNeeds),
            fixesNitrogen: crop.boolean('fixes_nitrogen'),
          ),
      };

  final JsonObject json;
  final Map<String, Crop> _crops;

  CropPlanningData toDomain() => CropPlanningData(
    areaHectares: json.number('area_ha'),
    availableCrops: _crops.values.toList(),
    irrigationSource: json.string('irrigation_source'),
    scenarioNotes: _textsByScenario(json.object('scenario_notes')),
    riskMonths: _datesByScenario(json.object('risk_months')),
    soilHealth: _soilHealth(json.object('soil_health')),
    currentPractice: _currentPractice(json.object('current_practice')),
    options: [for (final option in json.objects('options')) _option(option)],
    ranking: _ranking(json.object('ranking')),
    measuredRainNote: json.objectOrNull('recent_rain')?.string('finding'),
    waterAvailability: switch (json.objectOrNull('water_availability')) {
      final water? => WaterAvailability(
        level: water.oneOf('level', _waterLevels),
        finding: water.string('finding'),
        windowStart: water.date('window_start'),
        windowEnd: water.date('window_end'),
      ),
      null => null,
    },
  );

  Crop _crop(String id) =>
      _crops[id] ?? (throw FormatException('Cultivo desconocido.', id));

  SoilHealth _soilHealth(JsonObject soil) => SoilHealth(
    condition: soil.oneOf('condition', _soilConditions),
    findings: soil.strings('findings'),
  );

  CurrentPractice _currentPractice(JsonObject practice) => CurrentPractice(
    crops: [for (final id in practice.strings('crop_ids')) _crop(id)],
    scenarios: _resultsByScenario(practice.object('scenarios')),
    soilInTwoYears: practice.oneOf('soil_in_two_years', _soilConditions),
    factsheet: _factsheet(practice.object('factsheet')),
    repeatWarnings: _textsByScenario(practice.object('repeat_warnings')),
    consecutiveCampaigns: practice.integer('consecutive_campaigns'),
    warnings: practice.stringsOrEmpty('warnings'),
  );

  RotationOption _option(JsonObject option) => RotationOption(
    id: option.string('id'),
    crops: [for (final id in option.strings('crop_ids')) _crop(id)],
    scenarios: _resultsByScenario(option.object('scenarios')),
    soilImpact: option.oneOf('soil_impact', _soilImpacts),
    soilInTwoYears: option.oneOf('soil_in_two_years', _soilConditions),
    factsheet: _factsheet(option.object('factsheet')),
    schedule: _schedule(option.object('calendar')),
    longTermPlan: [
      for (final step in option.objects('long_term_plan'))
        CampaignStep(
          start: step.date('start'),
          end: step.date('end'),
          crop: _crop(step.string('crop_id')),
          soilAfter: step.oneOf('soil_after', _soilConditions),
        ),
    ],
    excludedBy: Set.unmodifiable(option.strings('excluded_by')),
    warnings: option.stringsOrEmpty('warnings'),
  );

  PlantingSchedule _schedule(JsonObject calendar) => PlantingSchedule(
    decisionDeadline: calendar.date('decision_deadline'),
    timelineStart: calendar.date('timeline_start'),
    timelineMonths: calendar.integer('timeline_months'),
    instructions: calendar.string('instructions'),
    periods: [
      for (final period in calendar.objects('periods'))
        CropPeriod(
          crop: _crop(period.string('crop_id')),
          start: period.date('start'),
          monthCount: period.integer('month_count'),
        ),
    ],
  );

  static OptionFactsheet _factsheet(JsonObject factsheet) => OptionFactsheet(
    rationale: factsheet.string('rationale'),
    evidence: factsheet.string('evidence'),
    benefits: factsheet.string('benefits'),
    unknowns: factsheet.string('unknowns'),
    risks: factsheet.string('risks'),
  );

  static Map<ClimateScenario, RotationScenarioResult> _resultsByScenario(
    JsonObject scenarios,
  ) => {
    for (final entry in _scenarios.entries)
      entry.value: _result(scenarios.object(entry.key)),
  };

  static RotationScenarioResult _result(JsonObject result) =>
      RotationScenarioResult(
        waterUseM3: result.integer('irrigation_m3'),
        climateRisk: result.oneOf('climate_risk', _climateRisks),
        riskMonths: result.dates('risk_months'),
      );

  static Map<ClimateScenario, String> _textsByScenario(JsonObject texts) => {
    for (final entry in _scenarios.entries)
      entry.value: texts.string(entry.key),
  };

  static Map<ClimateScenario, List<DateTime>> _datesByScenario(
    JsonObject months,
  ) => {
    for (final entry in _scenarios.entries)
      entry.value: months.dates(entry.key),
  };

  static Map<String, Map<ClimateScenario, List<String>>> _ranking(
    JsonObject ranking,
  ) => {
    for (final priorityId in ranking.keys)
      priorityId: {
        for (final entry in _scenarios.entries)
          entry.value: ranking.object(priorityId).strings(entry.key),
      },
  };
}
