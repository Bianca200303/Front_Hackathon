import 'package:siembra_segura/core/l10n/app_language.dart';
import 'package:siembra_segura/features/crop_planning/domain/crop_planning_models.dart';
import 'package:siembra_segura/shared/data/mock_catalog.dart';
import 'package:siembra_segura/shared/data/mock_text.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';

/// Datos de ejemplo de la referencia (mvp.html). En la app real vienen del
/// motor de recomendación del backend (NASA POWER + parámetros agronómicos).
class MockCropPlanningRepository implements CropPlanningRepository {
  /// Crea el repositorio; [latency] simula la espera de la red y
  /// [language] es el idioma de los textos.
  MockCropPlanningRepository({
    this.latency = Duration.zero,
    this.language = AppLanguage.spanish,
  });

  /// Idioma de los textos de ejemplo.
  final AppLanguage language;

  /// Espera simulada antes de responder.
  final Duration latency;

  /// Respuestas recibidas; útil en desarrollo y pruebas.
  final List<PlantingFeedback> submittedFeedback = [];

  @override
  Future<CropPlanningData> getPlanningData(CropPlanningQuery query) async {
    await Future<void>.delayed(latency);
    final t = MockText(language);
    final data = _buildData(t);
    final custom = _customOption(query, t);
    if (custom == null) return data;
    return CropPlanningData(
      options: [...data.options, custom],
      currentPractice: data.currentPractice,
      soilHealth: data.soilHealth,
      scenarioNotes: data.scenarioNotes,
      riskMonths: data.riskMonths,
      irrigationSource: data.irrigationSource,
      areaHectares: data.areaHectares,
      availableCrops: data.availableCrops,
      measuredRainNote: data.measuredRainNote,
      ranking: data.ranking,
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
RotationOption? _customOption(CropPlanningQuery query, MockText t) {
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
        crop: t.crop(fact.crop),
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
        crop: t.crop(fact.crop),
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
    crops: [for (final fact in facts) t.crop(fact.crop)],
    scenarios: _scenarios(waterUseM3: water, riskMonths: _riskMonths),
    soilImpact: _impactOf(impactScore),
    soilInTwoYears: plan.last.soilAfter,
    factsheet: OptionFactsheet(
      rationale: t('Es la secuencia que armaste tú.'),
      evidence: t(
        'Se calcula con los mismos datos que las demás opciones: lluvia y '
        'temperatura de la NASA, suelo del valle y el agua que pide cada '
        'cultivo.',
      ),
      benefits: t(
        'Puedes probar combinaciones y ver cómo cambian agua y tierra.',
      ),
      unknowns: t(
        'No sabemos si tienes comprador para todos estos cultivos ni si tu '
        'turno de riego alcanza.',
      ),
      risks: t('Conversa esta secuencia con tu técnico antes de sembrar.'),
    ),
    schedule: PlantingSchedule(
      decisionDeadline: query.plantingDate,
      timelineStart: start,
      timelineMonths: cursor,
      periods: periods,
      instructions: t(
        'Siembra {crop} en la fecha que elegiste y sigue con los demás '
        'cultivos al cosechar.',
      ).replaceAll('{crop}', t.crop(facts.first.crop).name.toLowerCase()),
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

CropPlanningData _buildData(MockText t) => CropPlanningData(
  irrigationSource: 'Poechos',
  areaHectares: 2,
  measuredRainNote: t(
    'En tu chacra llovieron 4.2 mm en los últimos 30 días medidos por el '
    'satélite GPM: la lluvia va como en un año seco.',
  ),
  availableCrops: [
    t.crop(MockCatalog.rice),
    t.crop(MockCatalog.maize),
    t.crop(MockCatalog.cotton),
    t.crop(MockCatalog.bean),
    t.crop(MockCatalog.pulse),
  ],
  scenarioNotes: {
    ClimateScenario.heavyRains: t('Con lluvias fuertes, '),
    ClimateScenario.normal: t('En un año normal, '),
    ClimateScenario.dry: t('En un año seco, '),
  },
  riskMonths: {
    ClimateScenario.heavyRains: _riskMonths,
    ClimateScenario.normal: const [],
    ClimateScenario.dry: const [],
  },
  soilHealth: SoilHealth(
    condition: SoilCondition.tired,
    findings: [
      t('Lleva 3 campañas seguidas de arroz.'),
      t(
        'El verdor de tus cultivos bajó en los últimos 5 años (satélite NASA).',
      ),
      t('Tiene poca materia orgánica.'),
    ],
  ),
  currentPractice: CurrentPractice(
    crops: [t.crop(MockCatalog.rice), t.crop(MockCatalog.rice)],
    scenarios: _scenarios(waterUseM3: 29000, riskMonths: _riskMonths),
    soilInTwoYears: SoilCondition.veryTired,
    consecutiveCampaigns: 3,
    repeatWarnings: {
      ClimateScenario.heavyRains: t(
        'Con lluvias fuertes el arroz puede inundarse y pierdes la '
        'campaña; además tu tierra se cansa más.',
      ),
      ClimateScenario.normal: t(
        'Gastas mucha más agua que con cualquier rotación y cansas tu '
        'tierra.',
      ),
      ClimateScenario.dry: t(
        'En un año seco puede faltarte agua para terminar la campaña.',
      ),
    },
    factsheet: OptionFactsheet(
      rationale: t(
        'Es lo que siembras hoy. Lo comparamos para que veas la diferencia.',
      ),
      evidence: t(
        'Tu parcela lleva 3 campañas de arroz y su verdor bajó en 5 años '
        '(Landsat). Es el cultivo que más agua consume (ECOSTRESS y FAO-56).',
      ),
      benefits: t('Ya conoces el cultivo y tienes comprador.'),
      unknowns: t('Depende de cuánta agua tenga Poechos este año.'),
      risks: t(
        'Con lluvias fuertes puede inundarse y perder la campaña. Tu '
        'tierra se sigue cansando.',
      ),
    ),
  ),
  options: [
    RotationOption(
      id: 'r1',
      crops: [t.crop(MockCatalog.maize), t.crop(MockCatalog.bean)],
      scenarios: _scenarios(waterUseM3: 15600, riskMonths: _riskMonths),
      soilImpact: SoilImpact.improvesALot,
      soilInTwoYears: SoilCondition.good,
      factsheet: OptionFactsheet(
        rationale: t(
          'El frejol le devuelve fuerza a tu tierra y el maíz aguanta mejor '
          'el clima que el arroz.',
        ),
        evidence: t(
          'En los años con El Niño (1998, 2017 y 2023) el maíz del valle '
          'perdió menos verdor que el arroz (lluvia GPM y verdor MODIS). El '
          'frejol fija nitrógeno en la tierra (FAO).',
        ),
        benefits: t(
          'Devuelve nitrógeno a la tierra, corta las plagas del arroz y usa '
          'la mitad de agua.',
        ),
        unknowns: t(
          'No tenemos un análisis de suelo de tu parcela. El precio del maíz '
          'en la cosecha puede cambiar.',
        ),
        risks: t(
          'Confirma con tu técnico la variedad de maíz para tu zona y si hay '
          'comprador cerca.',
        ),
      ),
      schedule: PlantingSchedule(
        decisionDeadline: DateTime(2026, 12, 15),
        timelineStart: _month(2026, 12),
        timelineMonths: 8,
        periods: [
          CropPeriod(
            crop: t.crop(MockCatalog.maize),
            start: _month(2026, 12),
            monthCount: 4,
          ),
          CropPeriod(
            crop: t.crop(MockCatalog.bean),
            start: _month(2027, 4),
            monthCount: 4,
          ),
        ],
        instructions: t(
          'Siembra el maíz entre el 1 y el 20 de diciembre. Cosecha antes de '
          'las lluvias más fuertes de marzo.',
        ),
      ),
      longTermPlan: [
        CampaignStep(
          start: _month(2026, 12),
          end: _month(2027, 3),
          crop: t.crop(MockCatalog.maize),
          soilAfter: SoilCondition.tired,
        ),
        CampaignStep(
          start: _month(2027, 4),
          end: _month(2027, 7),
          crop: t.crop(MockCatalog.bean),
          soilAfter: SoilCondition.regular,
        ),
        CampaignStep(
          start: _month(2027, 12),
          end: _month(2028, 5),
          crop: t.crop(MockCatalog.cotton),
          soilAfter: SoilCondition.regular,
        ),
        CampaignStep(
          start: _month(2028, 6),
          end: _month(2028, 8),
          crop: t.crop(MockCatalog.pulse),
          soilAfter: SoilCondition.good,
        ),
      ],
    ),
    RotationOption(
      id: 'r2',
      crops: [t.crop(MockCatalog.cotton), t.crop(MockCatalog.pulse)],
      scenarios: _scenarios(waterUseM3: 18200, riskMonths: _riskMonths),
      soilImpact: SoilImpact.improves,
      soilInTwoYears: SoilCondition.regular,
      excludedBy: {MockCatalog.noCottonBuyer.id, MockCatalog.lowWater.id},
      factsheet: OptionFactsheet(
        rationale: t(
          'El algodón tolera bien el calor y la menestra después cuida tu '
          'tierra.',
        ),
        evidence: t(
          'El algodón tolera bien el calor (FAO ECOCROP) y tiene historia en '
          'el valle. La menestra fija nitrógeno.',
        ),
        benefits: t(
          'Su raíz profunda mejora la estructura de la tierra y la menestra '
          'la abona.',
        ),
        unknowns: t(
          'No sabemos si tienes comprador o desmotadora cerca. Los precios '
          'del algodón varían mucho.',
        ),
        risks: t(
          'En años lluviosos aumentan las plagas del algodón: revisa con tu '
          'técnico cómo controlarlas.',
        ),
      ),
      schedule: PlantingSchedule(
        decisionDeadline: DateTime(2026, 11, 30),
        timelineStart: _month(2026, 12),
        timelineMonths: 8,
        periods: [
          CropPeriod(
            crop: t.crop(MockCatalog.cotton),
            start: _month(2026, 12),
            monthCount: 6,
          ),
          CropPeriod(
            crop: t.crop(MockCatalog.pulse),
            start: _month(2027, 6),
            monthCount: 2,
          ),
        ],
        instructions: t(
          'Siembra el algodón en la primera quincena de diciembre.',
        ),
      ),
      longTermPlan: [
        CampaignStep(
          start: _month(2026, 12),
          end: _month(2027, 5),
          crop: t.crop(MockCatalog.cotton),
          soilAfter: SoilCondition.tired,
        ),
        CampaignStep(
          start: _month(2027, 6),
          end: _month(2027, 8),
          crop: t.crop(MockCatalog.pulse),
          soilAfter: SoilCondition.regular,
        ),
        CampaignStep(
          start: _month(2027, 12),
          end: _month(2028, 3),
          crop: t.crop(MockCatalog.maize),
          soilAfter: SoilCondition.regular,
        ),
        CampaignStep(
          start: _month(2028, 4),
          end: _month(2028, 7),
          crop: t.crop(MockCatalog.bean),
          soilAfter: SoilCondition.regular,
        ),
      ],
    ),
    RotationOption(
      id: 'r3',
      crops: [t.crop(MockCatalog.bean), t.crop(MockCatalog.maize)],
      scenarios: _scenarios(waterUseM3: 13800, riskMonths: _riskMonths),
      soilImpact: SoilImpact.improves,
      soilInTwoYears: SoilCondition.good,
      factsheet: OptionFactsheet(
        rationale: t(
          'Son los cultivos que menos riego necesitan, y el frejol prepara la '
          'tierra para el maíz.',
        ),
        evidence: t(
          'Frejol y maíz necesitan menos agua (evapotranspiración de '
          'ECOSTRESS y FAO-56). El agua subterránea del valle viene bajando '
          '(GRACE).',
        ),
        benefits: t(
          'Es la opción que menos agua usa y el frejol prepara la tierra para '
          'el maíz.',
        ),
        unknowns: t(
          'Con lluvias muy fuertes el frejol rinde menos. Los datos de suelo '
          'son estimados (SoilGrids).',
        ),
        risks: t(
          'Confirma tu turno de riego con la junta de usuarios antes de '
          'sembrar.',
        ),
      ),
      schedule: PlantingSchedule(
        decisionDeadline: DateTime(2026, 12, 15),
        timelineStart: _month(2026, 12),
        timelineMonths: 8,
        periods: [
          CropPeriod(
            crop: t.crop(MockCatalog.bean),
            start: _month(2026, 12),
            monthCount: 3,
          ),
          CropPeriod(
            crop: t.crop(MockCatalog.maize),
            start: _month(2027, 3),
            monthCount: 5,
          ),
        ],
        instructions: t(
          'Siembra el frejol cuando confirmes tu turno de riego.',
        ),
      ),
      longTermPlan: [
        CampaignStep(
          start: _month(2026, 12),
          end: _month(2027, 2),
          crop: t.crop(MockCatalog.bean),
          soilAfter: SoilCondition.regular,
        ),
        CampaignStep(
          start: _month(2027, 3),
          end: _month(2027, 7),
          crop: t.crop(MockCatalog.maize),
          soilAfter: SoilCondition.regular,
        ),
        CampaignStep(
          start: _month(2027, 12),
          end: _month(2028, 2),
          crop: t.crop(MockCatalog.pulse),
          soilAfter: SoilCondition.good,
        ),
        CampaignStep(
          start: _month(2028, 3),
          end: _month(2028, 8),
          crop: t.crop(MockCatalog.cotton),
          soilAfter: SoilCondition.good,
        ),
      ],
    ),
  ],
);
