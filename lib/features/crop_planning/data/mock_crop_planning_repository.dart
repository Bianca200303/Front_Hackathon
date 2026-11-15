import 'package:siembra_segura/features/crop_planning/domain/crop_planning_models.dart';
import 'package:siembra_segura/shared/data/mock_catalog.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';

/// Datos de ejemplo de la referencia (mvp.html). En la app real vienen del
/// motor de recomendación del backend (NASA POWER + parámetros agronómicos).
class MockCropPlanningRepository implements CropPlanningRepository {
  /// Crea el repositorio; [latency] simula la espera de la red.
  MockCropPlanningRepository({this.latency = Duration.zero});

  /// Espera simulada antes de responder.
  final Duration latency;

  /// Respuestas recibidas; útil en desarrollo y pruebas.
  final List<PlantingFeedback> submittedFeedback = [];

  @override
  Future<CropPlanningData> getPlanningData(CropPlanningQuery query) async {
    await Future<void>.delayed(latency);
    final custom = _customOption(query);
    if (custom == null) return _data;
    return CropPlanningData(
      options: [..._data.options, custom],
      currentPractice: _data.currentPractice,
      soilHealth: _data.soilHealth,
      scenarioNotes: _data.scenarioNotes,
      riskMonths: _data.riskMonths,
      irrigationSource: _data.irrigationSource,
      areaHectares: _data.areaHectares,
      availableCrops: _data.availableCrops,
      measuredRainNote: _data.measuredRainNote,
      ranking: _data.ranking,
    );
  }

  @override
  Future<void> submitPlantingFeedback(PlantingFeedback feedback) async {
    await Future<void>.delayed(latency);
    submittedFeedback.add(feedback);
  }
}

DateTime _month(int year, int month) => DateTime(year, month);

DateTime _addMonths(DateTime start, int months) =>
    DateTime(start.year, start.month + months);

/// Lo mínimo que hace falta para armar una rotación a mano con los datos
/// de ejemplo. El cálculo real lo hace el backend.
class _CropFact {
  const _CropFact(this.crop, this.waterPerMonth, this.soilScore);

  final Crop crop;
  final int waterPerMonth;
  final int soilScore;

  /// Duración del ciclo: la del propio cultivo del catálogo de ejemplo.
  int get months => crop.cycleMonths ?? 1;
}

const _cropFacts = <String, _CropFact>{
  'rice': _CropFact(MockCatalog.rice, 2900, -1),
  'maize': _CropFact(MockCatalog.maize, 2000, 0),
  'bean': _CropFact(MockCatalog.bean, 1900, 2),
  'cotton': _CropFact(MockCatalog.cotton, 2100, 1),
  'pulse': _CropFact(MockCatalog.pulse, 2800, 2),
};

const _soilScale = [
  SoilCondition.veryTired,
  SoilCondition.tired,
  SoilCondition.regular,
  SoilCondition.good,
];
const _soilNowScore = 1;
const _horizonMonths = 24;

SoilImpact _impactOf(int score) => switch (score) {
  < 0 => SoilImpact.degrades,
  0 => SoilImpact.neutral,
  1 => SoilImpact.improves,
  _ => SoilImpact.improvesALot,
};

SoilCondition _conditionOf(int score) =>
    _soilScale[score.clamp(0, _soilScale.length - 1)];

/// La rotación que armó el agricultor, con el mismo detalle que las demás.
RotationOption? _customOption(CropPlanningQuery query) {
  final facts = [
    for (final id in query.customRotation)
      if (_cropFacts[id] != null) _cropFacts[id]!,
  ];
  if (facts.isEmpty) return null;

  final start = _month(query.plantingDate.year, query.plantingDate.month);
  final periods = <CropPeriod>[];
  var cursor = 0;
  for (final fact in facts) {
    periods.add(
      CropPeriod(
        crop: fact.crop,
        start: _addMonths(start, cursor),
        monthCount: fact.months,
      ),
    );
    cursor += fact.months;
  }

  final plan = <CampaignStep>[];
  var score = _soilNowScore;
  var offset = 0;
  var index = 0;
  while (offset < _horizonMonths) {
    final fact = facts[index % facts.length];
    score = (score + fact.soilScore).clamp(0, _soilScale.length - 1);
    plan.add(
      CampaignStep(
        start: _addMonths(start, offset),
        end: _addMonths(start, offset + fact.months - 1),
        crop: fact.crop,
        soilAfter: _conditionOf(score),
      ),
    );
    offset += fact.months;
    index++;
  }

  final water = facts.fold(0, (sum, f) => sum + f.months * f.waterPerMonth);
  final impactScore = facts.fold(0, (sum, f) => sum + f.soilScore);
  final cropIds = facts.map((fact) => fact.crop.id).toSet();
  return RotationOption(
    id: CropPlanningData.customRotationId,
    crops: [for (final fact in facts) fact.crop],
    scenarios: _scenarios(waterUseM3: water, riskMonths: _riskMonths),
    soilImpact: _impactOf(impactScore),
    soilInTwoYears: plan.last.soilAfter,
    factsheet: const OptionFactsheet(
      rationale: 'Es la secuencia que armaste tú.',
      evidence:
          'Se calcula con los mismos datos que las demás opciones: lluvia y '
          'temperatura de la NASA, suelo del valle y el agua que pide cada '
          'cultivo.',
      benefits: 'Puedes probar combinaciones y ver cómo cambian agua y tierra.',
      unknowns:
          'No sabemos si tienes comprador para todos estos cultivos ni si tu '
          'turno de riego alcanza.',
      risks: 'Conversa esta secuencia con tu técnico antes de sembrar.',
    ),
    schedule: PlantingSchedule(
      decisionDeadline: query.plantingDate,
      timelineStart: start,
      timelineMonths: cursor,
      periods: periods,
      instructions:
          'Siembra ${facts.first.crop.name.toLowerCase()} en la fecha que '
          'elegiste y sigue con los demás cultivos al cosechar.',
    ),
    longTermPlan: plan,
    excludedBy: {
      if (cropIds.contains(MockCatalog.cotton.id)) MockCatalog.noCottonBuyer.id,
      if (water > 18000) MockCatalog.lowWater.id,
    },
  );
}

final _riskMonths = [_month(2027, 2), _month(2027, 3)];

ClimateRisk _riskOf(List<DateTime> riskMonths) => switch (riskMonths.length) {
  0 => ClimateRisk.low,
  1 => ClimateRisk.medium,
  _ => ClimateRisk.high,
};

/// Agua y riesgo de una opción: con lluvias fuertes riega menos pero
/// arriesga más; en un año seco, al revés.
Map<ClimateScenario, RotationScenarioResult> _scenarios({
  required int waterUseM3,
  required List<DateTime> riskMonths,
}) => {
  ClimateScenario.heavyRains: RotationScenarioResult(
    waterUseM3: (waterUseM3 * 0.7).round(),
    climateRisk: _riskOf(riskMonths),
    riskMonths: riskMonths,
  ),
  ClimateScenario.normal: RotationScenarioResult(
    waterUseM3: waterUseM3,
    climateRisk: ClimateRisk.low,
    riskMonths: const [],
  ),
  ClimateScenario.dry: RotationScenarioResult(
    waterUseM3: (waterUseM3 * 1.2).round(),
    climateRisk: ClimateRisk.low,
    riskMonths: const [],
  ),
};

final _data = CropPlanningData(
  irrigationSource: 'Poechos',
  areaHectares: 2,
  measuredRainNote:
      'En tu chacra llovieron 4.2 mm en los últimos 30 días medidos por el '
      'satélite GPM: la lluvia va como en un año seco.',
  availableCrops: const [
    MockCatalog.rice,
    MockCatalog.maize,
    MockCatalog.cotton,
    MockCatalog.bean,
    MockCatalog.pulse,
  ],
  scenarioNotes: const {
    ClimateScenario.heavyRains: 'Con lluvias fuertes, ',
    ClimateScenario.normal: 'En un año normal, ',
    ClimateScenario.dry: 'En un año seco, ',
  },
  riskMonths: {
    ClimateScenario.heavyRains: _riskMonths,
    ClimateScenario.normal: const [],
    ClimateScenario.dry: const [],
  },
  soilHealth: const SoilHealth(
    condition: SoilCondition.tired,
    findings: [
      'Lleva 3 campañas seguidas de arroz.',
      'El verdor de tus cultivos bajó en los últimos 5 años (satélite NASA).',
      'Tiene poca materia orgánica.',
    ],
  ),
  currentPractice: CurrentPractice(
    crops: const [MockCatalog.rice, MockCatalog.rice],
    scenarios: _scenarios(waterUseM3: 29000, riskMonths: _riskMonths),
    soilInTwoYears: SoilCondition.veryTired,
    consecutiveCampaigns: 3,
    repeatWarnings: const {
      ClimateScenario.heavyRains:
          'Con lluvias fuertes el arroz puede inundarse y pierdes la '
          'campaña; además tu tierra se cansa más.',
      ClimateScenario.normal:
          'Gastas mucha más agua que con cualquier rotación y cansas tu '
          'tierra.',
      ClimateScenario.dry:
          'En un año seco puede faltarte agua para terminar la campaña.',
    },
    factsheet: const OptionFactsheet(
      rationale:
          'Es lo que siembras hoy. Lo comparamos para que veas la diferencia.',
      evidence:
          'Tu parcela lleva 3 campañas de arroz y su verdor bajó en 5 años '
          '(Landsat). Es el cultivo que más agua consume (ECOSTRESS y FAO-56).',
      benefits: 'Ya conoces el cultivo y tienes comprador.',
      unknowns: 'Depende de cuánta agua tenga Poechos este año.',
      risks:
          'Con lluvias fuertes puede inundarse y perder la campaña. Tu '
          'tierra se sigue cansando.',
    ),
  ),
  options: [
    RotationOption(
      id: 'r1',
      crops: const [MockCatalog.maize, MockCatalog.bean],
      scenarios: _scenarios(waterUseM3: 15600, riskMonths: _riskMonths),
      soilImpact: SoilImpact.improvesALot,
      soilInTwoYears: SoilCondition.good,
      factsheet: const OptionFactsheet(
        rationale:
            'El frejol le devuelve fuerza a tu tierra y el maíz aguanta mejor '
            'el clima que el arroz.',
        evidence:
            'En los años con El Niño (1998, 2017 y 2023) el maíz del valle '
            'perdió menos verdor que el arroz (lluvia GPM y verdor MODIS). El '
            'frejol fija nitrógeno en la tierra (FAO).',
        benefits:
            'Devuelve nitrógeno a la tierra, corta las plagas del arroz y usa '
            'la mitad de agua.',
        unknowns:
            'No tenemos un análisis de suelo de tu parcela. El precio del maíz '
            'en la cosecha puede cambiar.',
        risks:
            'Confirma con tu técnico la variedad de maíz para tu zona y si hay '
            'comprador cerca.',
      ),
      schedule: PlantingSchedule(
        decisionDeadline: DateTime(2026, 12, 15),
        timelineStart: _month(2026, 12),
        timelineMonths: 8,
        periods: [
          CropPeriod(
            crop: MockCatalog.maize,
            start: _month(2026, 12),
            monthCount: 4,
          ),
          CropPeriod(
            crop: MockCatalog.bean,
            start: _month(2027, 4),
            monthCount: 4,
          ),
        ],
        instructions:
            'Siembra el maíz entre el 1 y el 20 de diciembre. Cosecha antes de '
            'las lluvias más fuertes de marzo.',
      ),
      longTermPlan: [
        CampaignStep(
          start: _month(2026, 12),
          end: _month(2027, 3),
          crop: MockCatalog.maize,
          soilAfter: SoilCondition.tired,
        ),
        CampaignStep(
          start: _month(2027, 4),
          end: _month(2027, 7),
          crop: MockCatalog.bean,
          soilAfter: SoilCondition.regular,
        ),
        CampaignStep(
          start: _month(2027, 12),
          end: _month(2028, 5),
          crop: MockCatalog.cotton,
          soilAfter: SoilCondition.regular,
        ),
        CampaignStep(
          start: _month(2028, 6),
          end: _month(2028, 8),
          crop: MockCatalog.pulse,
          soilAfter: SoilCondition.good,
        ),
      ],
    ),
    RotationOption(
      id: 'r2',
      crops: const [MockCatalog.cotton, MockCatalog.pulse],
      scenarios: _scenarios(waterUseM3: 18200, riskMonths: _riskMonths),
      soilImpact: SoilImpact.improves,
      soilInTwoYears: SoilCondition.regular,
      excludedBy: {MockCatalog.noCottonBuyer.id, MockCatalog.lowWater.id},
      factsheet: const OptionFactsheet(
        rationale:
            'El algodón tolera bien el calor y la menestra después cuida tu '
            'tierra.',
        evidence:
            'El algodón tolera bien el calor (FAO ECOCROP) y tiene historia en '
            'el valle. La menestra fija nitrógeno.',
        benefits:
            'Su raíz profunda mejora la estructura de la tierra y la menestra '
            'la abona.',
        unknowns:
            'No sabemos si tienes comprador o desmotadora cerca. Los precios '
            'del algodón varían mucho.',
        risks:
            'En años lluviosos aumentan las plagas del algodón: revisa con tu '
            'técnico cómo controlarlas.',
      ),
      schedule: PlantingSchedule(
        decisionDeadline: DateTime(2026, 11, 30),
        timelineStart: _month(2026, 12),
        timelineMonths: 8,
        periods: [
          CropPeriod(
            crop: MockCatalog.cotton,
            start: _month(2026, 12),
            monthCount: 6,
          ),
          CropPeriod(
            crop: MockCatalog.pulse,
            start: _month(2027, 6),
            monthCount: 2,
          ),
        ],
        instructions: 'Siembra el algodón en la primera quincena de diciembre.',
      ),
      longTermPlan: [
        CampaignStep(
          start: _month(2026, 12),
          end: _month(2027, 5),
          crop: MockCatalog.cotton,
          soilAfter: SoilCondition.tired,
        ),
        CampaignStep(
          start: _month(2027, 6),
          end: _month(2027, 8),
          crop: MockCatalog.pulse,
          soilAfter: SoilCondition.regular,
        ),
        CampaignStep(
          start: _month(2027, 12),
          end: _month(2028, 3),
          crop: MockCatalog.maize,
          soilAfter: SoilCondition.regular,
        ),
        CampaignStep(
          start: _month(2028, 4),
          end: _month(2028, 7),
          crop: MockCatalog.bean,
          soilAfter: SoilCondition.regular,
        ),
      ],
    ),
    RotationOption(
      id: 'r3',
      crops: const [MockCatalog.bean, MockCatalog.maize],
      scenarios: _scenarios(waterUseM3: 13800, riskMonths: _riskMonths),
      soilImpact: SoilImpact.improves,
      soilInTwoYears: SoilCondition.good,
      factsheet: const OptionFactsheet(
        rationale:
            'Son los cultivos que menos riego necesitan, y el frejol prepara la '
            'tierra para el maíz.',
        evidence:
            'Frejol y maíz necesitan menos agua (evapotranspiración de '
            'ECOSTRESS y FAO-56). El agua subterránea del valle viene bajando '
            '(GRACE).',
        benefits:
            'Es la opción que menos agua usa y el frejol prepara la tierra para '
            'el maíz.',
        unknowns:
            'Con lluvias muy fuertes el frejol rinde menos. Los datos de suelo '
            'son estimados (SoilGrids).',
        risks:
            'Confirma tu turno de riego con la junta de usuarios antes de '
            'sembrar.',
      ),
      schedule: PlantingSchedule(
        decisionDeadline: DateTime(2026, 12, 15),
        timelineStart: _month(2026, 12),
        timelineMonths: 8,
        periods: [
          CropPeriod(
            crop: MockCatalog.bean,
            start: _month(2026, 12),
            monthCount: 3,
          ),
          CropPeriod(
            crop: MockCatalog.maize,
            start: _month(2027, 3),
            monthCount: 5,
          ),
        ],
        instructions: 'Siembra el frejol cuando confirmes tu turno de riego.',
      ),
      longTermPlan: [
        CampaignStep(
          start: _month(2026, 12),
          end: _month(2027, 2),
          crop: MockCatalog.bean,
          soilAfter: SoilCondition.regular,
        ),
        CampaignStep(
          start: _month(2027, 3),
          end: _month(2027, 7),
          crop: MockCatalog.maize,
          soilAfter: SoilCondition.regular,
        ),
        CampaignStep(
          start: _month(2027, 12),
          end: _month(2028, 2),
          crop: MockCatalog.pulse,
          soilAfter: SoilCondition.good,
        ),
        CampaignStep(
          start: _month(2028, 3),
          end: _month(2028, 8),
          crop: MockCatalog.cotton,
          soilAfter: SoilCondition.good,
        ),
      ],
    ),
  ],
);
