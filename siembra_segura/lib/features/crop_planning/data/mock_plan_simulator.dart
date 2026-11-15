import 'dart:math' as math;

import 'package:siembra_segura/core/l10n/app_language.dart';
import 'package:siembra_segura/features/crop_planning/domain/plan_simulation.dart';
import 'package:siembra_segura/shared/data/mock_catalog.dart';
import 'package:siembra_segura/shared/data/mock_text.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';

/// Cómo se comporta un cultivo en el modelo de ejemplo.
class _CropTraits {
  const _CropTraits({
    required this.waterM3,
    required this.soilDelta,
    required this.rainTolerance,
    required this.dryTolerance,
    required this.family,
    this.feedsSoil = false,
  });

  /// Agua por hectárea y campaña (FAO-56, ECOSTRESS).
  final int waterM3;

  /// Cuánto mejora (+) o cansa (−) la tierra en una campaña.
  final int soilDelta;

  /// Parte de la cosecha que se salva con lluvias fuertes (GPM).
  final double rainTolerance;

  /// Parte de la cosecha que se salva en un año seco.
  final double dryTolerance;

  /// Familia: repetir la misma seguido cansa la tierra y trae plagas.
  final String family;

  /// Leguminosas y abono verde: devuelven nitrógeno.
  final bool feedsSoil;
}

/// Modelo de ejemplo de "Prueba tu propio plan", con las reglas de
/// `semi_app.html`. Es una simplificación para la demo: el cálculo real
/// es del modelo del backend (B17). Todo con datos de clima, agua y tierra;
/// nada de precios.
class MockPlanSimulator implements PlanSimulator {
  /// Crea el simulador; [language] es el idioma de los nombres.
  const MockPlanSimulator({
    this.language = AppLanguage.spanish,
    this.latency = Duration.zero,
  });

  /// Idioma de los nombres de cultivo.
  final AppLanguage language;

  /// Espera simulada antes de responder.
  final Duration latency;

  static const _traits = <String, _CropTraits>{
    'rice': _CropTraits(
      waterM3: 14500,
      soilDelta: -12,
      rainTolerance: 0.45,
      dryTolerance: 0.35,
      family: 'cereal',
    ),
    'maize': _CropTraits(
      waterM3: 7800,
      soilDelta: -4,
      rainTolerance: 0.85,
      dryTolerance: 0.75,
      family: 'cereal',
    ),
    'bean': _CropTraits(
      waterM3: 5000,
      soilDelta: 12,
      rainTolerance: 0.75,
      dryTolerance: 0.85,
      family: 'legume',
      feedsSoil: true,
    ),
    'cotton': _CropTraits(
      waterM3: 9100,
      soilDelta: -2,
      rainTolerance: 0.6,
      dryTolerance: 0.8,
      family: 'fiber',
    ),
    'pulse': _CropTraits(
      waterM3: 4500,
      soilDelta: 10,
      rainTolerance: 0.8,
      dryTolerance: 0.9,
      family: 'legume',
      feedsSoil: true,
    ),
    'green-manure': _CropTraits(
      waterM3: 3000,
      soilDelta: 18,
      rainTolerance: 1,
      dryTolerance: 1,
      family: 'green-manure',
      feedsSoil: true,
    ),
  };

  /// Para un cultivo que el modelo no conoce: sin efecto.
  static const _neutral = _CropTraits(
    waterM3: 8000,
    soilDelta: 0,
    rainTolerance: 0.7,
    dryTolerance: 0.7,
    family: 'other',
  );

  /// Agua que habría en Poechos en cada campaña (escenario más probable).
  static const _waterAvailable = [12000, 9000, 10000, 8000];

  @override
  Future<List<SimulationCrop>> availableCrops() async {
    await Future<void>.delayed(latency);
    final t = MockText(language);
    return [
      SimulationCrop(crop: t.crop(MockCatalog.rice)),
      SimulationCrop(crop: t.crop(MockCatalog.maize)),
      SimulationCrop(crop: t.crop(MockCatalog.bean)),
      SimulationCrop(
        crop: t.crop(MockCatalog.cotton),
        excludedBy: {MockCatalog.noCottonBuyer.id},
      ),
      SimulationCrop(crop: t.crop(MockCatalog.pulse)),
      SimulationCrop(crop: t.crop(MockCatalog.greenManure), harvested: false),
    ];
  }

  @override
  Future<PlanSimulation> simulate({
    required List<Crop> plan,
    required Crop previousCrop,
    required SoilCondition soilToday,
    required ClimateScenario firstSeason,
  }) async {
    await Future<void>.delayed(latency);
    var soil = _soilScore(soilToday);
    var water = 0;
    var previous = _traitsOf(previousCrop);
    final campaigns = <SimulatedCampaign>[];

    for (final (index, crop) in plan.indexed) {
      final traits = _traitsOf(crop);
      final season = index == 0 ? firstSeason : ClimateScenario.normal;
      final available = _waterAvailable[index % _waterAvailable.length];

      var soilDelta = traits.soilDelta;
      var factor = switch (season) {
        ClimateScenario.heavyRains => traits.rainTolerance,
        ClimateScenario.dry => traits.dryTolerance,
        ClimateScenario.normal => 1.0,
      };
      // Repetir la familia cansa la tierra y acumula plagas.
      if (previous.family == traits.family && traits.family != 'green-manure') {
        soilDelta -= 10;
        factor *= 0.7;
      }
      if (traits.feedsSoil && !previous.feedsSoil) soilDelta += 3;
      // Con menos agua de la que pide, rinde menos.
      if (traits.waterM3 > available) factor *= available / traits.waterM3;

      final harvested = crop.id != MockCatalog.greenManure.id;
      final harvest = harvested
          ? (factor * (0.75 + soil / 250)).clamp(0.0, 1.0)
          : null;
      soil = (soil + soilDelta).clamp(0, 100);
      water += math.min(traits.waterM3, available);
      campaigns.add(
        SimulatedCampaign(
          crop: crop,
          harvest: harvest,
          soilAfter: _soilCondition(soil),
        ),
      );
      previous = traits;
    }
    return PlanSimulation(campaigns: campaigns, waterUseM3: water);
  }

  static _CropTraits _traitsOf(Crop crop) => _traits[crop.id] ?? _neutral;

  static int _soilScore(SoilCondition condition) => switch (condition) {
    SoilCondition.veryTired => 20,
    SoilCondition.tired => 35,
    SoilCondition.regular => 55,
    SoilCondition.good => 70,
  };

  static SoilCondition _soilCondition(int score) => score >= 65
      ? SoilCondition.good
      : score >= 45
      ? SoilCondition.regular
      : score >= 25
      ? SoilCondition.tired
      : SoilCondition.veryTired;
}
