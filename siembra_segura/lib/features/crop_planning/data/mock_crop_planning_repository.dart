import 'package:siembra_segura/core/l10n/app_language.dart';
import 'package:siembra_segura/features/crop_planning/domain/crop_planning_models.dart';
import 'package:siembra_segura/shared/data/mock_catalog.dart';
import 'package:siembra_segura/shared/data/mock_text.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';

/// Datos de ejemplo de la referencia (mvp.html). En la app real vienen del
/// modelo de rotaciones, los históricos NASA y el pronóstico.
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
  Future<CropPlanningData> getPlanningData() async {
    await Future<void>.delayed(latency);
    return _buildData(MockText(language));
  }

  @override
  Future<void> submitPlantingFeedback(PlantingFeedback feedback) async {
    await Future<void>.delayed(latency);
    submittedFeedback.add(feedback);
  }
}

DateTime _month(int year, int month) => DateTime(year, month);

CropPlanningData _buildData(MockText t) => CropPlanningData(
  irrigationSource: 'Poechos',
  scenarioNotes: {
    ClimateScenario.heavyRains: t('Con El Niño llueve más; '),
    ClimateScenario.normal: t('En un año normal, '),
    ClimateScenario.dry: t('En un año seco, '),
  },
  riskMonths: {
    ClimateScenario.heavyRains: [_month(2027, 2), _month(2027, 3)],
    ClimateScenario.normal: [],
    ClimateScenario.dry: [],
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
    waterUseM3: 14500,
    soilInTwoYears: SoilCondition.veryTired,
    consecutiveCampaigns: 3,
    expectedHarvest: {
      ClimateScenario.heavyRains: 0.55,
      ClimateScenario.normal: 0.95,
      ClimateScenario.dry: 0.4,
    },
    repeatWarnings: {
      ClimateScenario.heavyRains: t(
        'Con El Niño es muy arriesgado: el arroz se inunda y podrías perder '
        'casi la mitad de tu cosecha.',
      ),
      ClimateScenario.normal: t(
        'Cosechas parecido, pero gastas mucha más agua y cansas tu tierra.',
      ),
      ClimateScenario.dry: t(
        'Sin agua suficiente podrías perder más de la mitad de la cosecha.',
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
      benefits: t('Ya conoces bien el cultivo.'),
      unknowns: t('Depende de cuánta agua tenga Poechos este año.'),
      risks: t(
        'Con lluvias fuertes puede inundarse y perder gran parte de la '
        'cosecha. Tu tierra se sigue cansando.',
      ),
    ),
  ),
  options: [
    RotationOption(
      id: 'r1',
      crops: [t.crop(MockCatalog.maize), t.crop(MockCatalog.bean)],
      waterUseM3: 7800,
      waterSummary: t('usa la mitad que el arroz'),
      soilImpact: SoilImpact.improvesALot,
      soilInTwoYears: SoilCondition.good,
      outcomes: {
        ClimateScenario.heavyRains: const ScenarioOutcome(
          expectedHarvest: 0.85,
          worstHarvest: 0.7,
        ),
        ClimateScenario.normal: const ScenarioOutcome(
          expectedHarvest: 0.9,
          worstHarvest: 0.8,
        ),
        ClimateScenario.dry: const ScenarioOutcome(
          expectedHarvest: 0.8,
          worstHarvest: 0.6,
        ),
      },
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
          'No tenemos un análisis de suelo de tu parcela. El pronóstico puede '
          'cambiar si El Niño se debilita.',
        ),
        risks: t('Confirma con tu técnico la variedad de maíz para tu zona.'),
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
      waterUseM3: 9100,
      waterSummary: t('usa menos que el arroz'),
      soilImpact: SoilImpact.improves,
      soilInTwoYears: SoilCondition.regular,
      excludedBy: {MockCatalog.noCottonBuyer.id, MockCatalog.lowWater.id},
      outcomes: {
        ClimateScenario.heavyRains: const ScenarioOutcome(
          expectedHarvest: 0.75,
          worstHarvest: 0.45,
        ),
        ClimateScenario.normal: const ScenarioOutcome(
          expectedHarvest: 0.95,
          worstHarvest: 0.75,
        ),
        ClimateScenario.dry: const ScenarioOutcome(
          expectedHarvest: 0.9,
          worstHarvest: 0.5,
        ),
      },
      factsheet: OptionFactsheet(
        rationale: t(
          'El algodón aguanta bien el calor y la menestra después cuida tu '
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
          'En años muy lluviosos el algodón pierde calidad. Los datos de suelo '
          'son estimados (SoilGrids).',
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
      waterUseM3: 6900,
      waterSummary: t('usa la menor cantidad'),
      soilImpact: SoilImpact.improves,
      soilInTwoYears: SoilCondition.good,
      outcomes: {
        ClimateScenario.heavyRains: const ScenarioOutcome(
          expectedHarvest: 0.7,
          worstHarvest: 0.6,
        ),
        ClimateScenario.normal: const ScenarioOutcome(
          expectedHarvest: 0.85,
          worstHarvest: 0.75,
        ),
        ClimateScenario.dry: const ScenarioOutcome(
          expectedHarvest: 0.75,
          worstHarvest: 0.7,
        ),
      },
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
