import 'package:siembra_segura/features/crop_planning/domain/crop_planning_models.dart';
import 'package:siembra_segura/shared/data/mock_catalog.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';

/// Datos de ejemplo de la referencia (mvp.html). En la app real vienen del
/// modelo de rotaciones, los históricos NASA y el pronóstico.
class MockCropPlanningRepository implements CropPlanningRepository {
  /// Crea el repositorio; [latency] simula la espera de la red.
  MockCropPlanningRepository({this.latency = Duration.zero});

  /// Espera simulada antes de responder.
  final Duration latency;

  /// Respuestas recibidas; útil en desarrollo y pruebas.
  final List<PlantingFeedback> submittedFeedback = [];

  @override
  Future<CropPlanningData> getPlanningData() async {
    await Future<void>.delayed(latency);
    return _data;
  }

  @override
  Future<void> submitPlantingFeedback(PlantingFeedback feedback) async {
    await Future<void>.delayed(latency);
    submittedFeedback.add(feedback);
  }
}

DateTime _month(int year, int month) => DateTime(year, month);

final _data = CropPlanningData(
  irrigationSource: 'Poechos',
  scenarioNotes: const {
    ClimateScenario.heavyRains: 'Con El Niño llueve más; ',
    ClimateScenario.normal: 'En un año normal, ',
    ClimateScenario.dry: 'En un año seco, ',
  },
  riskMonths: {
    ClimateScenario.heavyRains: [_month(2027, 2), _month(2027, 3)],
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
  currentPractice: const CurrentPractice(
    crops: [MockCatalog.rice, MockCatalog.rice],
    waterUseM3: 14500,
    soilInTwoYears: SoilCondition.veryTired,
    consecutiveCampaigns: 3,
    expectedProfit: {
      ClimateScenario.heavyRains: 3000,
      ClimateScenario.normal: 3400,
      ClimateScenario.dry: 1200,
    },
    repeatWarnings: {
      ClimateScenario.heavyRains:
          'Podrías ganar más, pero con El Niño es muy arriesgado: podrías '
          'perder hasta S/ 5,000.',
      ClimateScenario.normal:
          'Ganas parecido, pero gastas mucha más agua y cansas tu tierra.',
      ClimateScenario.dry:
          'Sin agua suficiente podrías perder la campaña: hasta S/ 6,200.',
    },
    factsheet: OptionFactsheet(
      rationale:
          'Es lo que siembras hoy. Lo comparamos para que veas la diferencia.',
      evidence:
          'Tu parcela lleva 3 campañas de arroz y su verdor bajó en 5 años '
          '(Landsat). Es el cultivo que más agua consume (ECOSTRESS y FAO-56).',
      benefits: 'Ya conoces el cultivo y tienes comprador.',
      unknowns: 'Depende de cuánta agua tenga Poechos este año.',
      risks:
          'Con lluvias fuertes puede inundarse y perder la campaña (hasta '
          'S/ 5,000). Tu tierra se sigue cansando.',
    ),
  ),
  options: [
    RotationOption(
      id: 'r1',
      crops: const [MockCatalog.maize, MockCatalog.bean],
      waterUseM3: 7800,
      waterSummary: 'usa la mitad que el arroz',
      soilImpact: SoilImpact.improvesALot,
      soilInTwoYears: SoilCondition.good,
      outcomes: const {
        ClimateScenario.heavyRains: ScenarioOutcome(
          expectedProfit: 2400,
          maxLoss: 600,
        ),
        ClimateScenario.normal: ScenarioOutcome(
          expectedProfit: 2500,
          maxLoss: 400,
        ),
        ClimateScenario.dry: ScenarioOutcome(
          expectedProfit: 2000,
          maxLoss: 900,
        ),
      },
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
      waterUseM3: 9100,
      waterSummary: 'usa menos que el arroz',
      soilImpact: SoilImpact.improves,
      soilInTwoYears: SoilCondition.regular,
      excludedBy: {MockCatalog.noCottonBuyer.id, MockCatalog.lowWater.id},
      outcomes: const {
        ClimateScenario.heavyRains: ScenarioOutcome(
          expectedProfit: 2300,
          maxLoss: 1900,
        ),
        ClimateScenario.normal: ScenarioOutcome(
          expectedProfit: 3100,
          maxLoss: 700,
        ),
        ClimateScenario.dry: ScenarioOutcome(
          expectedProfit: 2300,
          maxLoss: 2000,
        ),
      },
      factsheet: const OptionFactsheet(
        rationale:
            'El algodón da buena plata y la menestra después cuida tu tierra.',
        evidence:
            'El algodón tolera bien el calor (FAO ECOCROP) y tiene historia en '
            'el valle. La menestra fija nitrógeno.',
        benefits:
            'Buen precio. Su raíz profunda mejora la estructura de la tierra y '
            'la menestra la abona.',
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
      waterUseM3: 6900,
      waterSummary: 'usa la menor cantidad',
      soilImpact: SoilImpact.improves,
      soilInTwoYears: SoilCondition.good,
      outcomes: const {
        ClimateScenario.heavyRains: ScenarioOutcome(
          expectedProfit: 1800,
          maxLoss: 400,
        ),
        ClimateScenario.normal: ScenarioOutcome(
          expectedProfit: 2000,
          maxLoss: 300,
        ),
        ClimateScenario.dry: ScenarioOutcome(
          expectedProfit: 1900,
          maxLoss: 500,
        ),
      },
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
