import 'package:flutter/painting.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/theme/app_colors.dart';
import 'package:siembra_segura/core/utils/formatters.dart';
import 'package:siembra_segura/features/crop_planning/domain/crop_planning_models.dart';
import 'package:siembra_segura/features/crop_planning/domain/recommendation.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';
import 'package:siembra_segura/shared/presentation/vocabulary_labels.dart';

/// Textos derivados de la recomendación: títulos, razones y narraciones.
///
/// Funciones puras (sin widgets) para poder probarlas de forma aislada.
extension SoilImpactLabels on SoilImpact {
  /// Texto del impacto en el suelo.
  String label(AppLocalizations l10n) => switch (this) {
    SoilImpact.improves => l10n.soilImpactImproves,
    SoilImpact.improvesALot => l10n.soilImpactImprovesALot,
  };
}

/// Color de cada escenario en las barras de probabilidad.
extension ScenarioColors on ClimateScenario {
  /// Color del escenario.
  Color get color => switch (this) {
    ClimateScenario.heavyRains => AppColors.water,
    ClimateScenario.normal => AppColors.scenarioNormal,
    ClimateScenario.dry => AppColors.heat,
  };
}

/// Nombre de una rotación.
extension RotationOptionTexts on RotationOption {
  /// Por ejemplo, "Maíz y después frejol".
  String name(AppLocalizations l10n) => cropSequenceName(crops, l10n);
}

/// Nombre de la práctica actual.
extension CurrentPracticeTexts on CurrentPractice {
  /// Por ejemplo, "Arroz y arroz".
  String name(AppLocalizations l10n) => cropSequenceName(crops, l10n);
}

/// "Maíz – Mar" → "Dic–Mar".
String periodLabel(DateTime start, DateTime end) =>
    '${AppFormatters.shortMonth(start)}–${AppFormatters.shortMonth(end)}';

/// Textos de la recomendación para las pantallas y "Escuchar".
extension RecommendationTexts on Recommendation {
  /// "TE RECOMENDAMOS" o "SI EL AÑO VIENE SECO, TE CONVIENE".
  String headline(AppLocalizations l10n) {
    if (isMostLikelyScenario) return l10n.recommendationHeadline;
    return switch (scenario) {
      ClimateScenario.heavyRains => l10n.recommendationIfHeavyRains,
      ClimateScenario.normal => l10n.recommendationIfNormal,
      ClimateScenario.dry => l10n.recommendationIfDry,
    };
  }

  /// Por qué se recomienda, introducido por el escenario.
  String rationale() =>
      '$scenarioNote${AppFormatters.lowercaseFirst(best.factsheet.rationale)}';

  /// Qué pasa si repite el cultivo en el escenario.
  String repeatWarning() => currentPractice.repeatWarnings[scenario] ?? '';

  /// Razones de la recomendación (pantalla "¿Cuándo siembro?").
  List<String> reasons(AppLocalizations l10n) {
    final currentCrop = currentPractice.mainCrop.name.toLowerCase();
    final count = currentPractice.consecutiveCampaigns;
    return [
      rationale(),
      switch (best.soilImpact) {
        SoilImpact.improvesALot => l10n.scheduleReasonSoilRestores(
          count,
          currentCrop,
        ),
        SoilImpact.improves => l10n.scheduleReasonSoilHelps(count, currentCrop),
      },
      l10n.scheduleReasonWater(data.irrigationSource, currentCrop),
    ];
  }

  /// "Maíz y después frejol y después algodón y menestra."
  String longTermPlanName(AppLocalizations l10n) {
    final later = best.longTermPlan
        .skip(best.crops.length)
        .map((step) => step.crop.name.toLowerCase())
        .toList();
    if (later.isEmpty) return '${best.name(l10n)}.';
    return l10n.rotationPlanName(best.name(l10n), joinWithAnd(later, l10n));
  }

  /// Narración de "Qué sembrar".
  String recommendationNarration(AppLocalizations l10n) {
    final outcome = bestOutcome;
    return l10n.recommendationNarration(
      AppFormatters.monthName(outlook.horizonEnd),
      outlook.mostLikely.label(l10n).toLowerCase(),
      AppFormatters.percent(outlook.probabilityOf(outlook.mostLikely)),
      priority.phrase,
      best.name(l10n),
      AppFormatters.soles(outcome.expectedProfit),
      AppFormatters.soles(outcome.maxLoss),
      best.soilImpact.label(l10n),
      repeatWarning(),
    );
  }

  /// Narración de "¿Cuándo siembro?".
  String scheduleNarration(AppLocalizations l10n) => l10n.scheduleNarration(
    best.name(l10n),
    AppFormatters.dayAndMonth(best.schedule.decisionDeadline),
    best.schedule.instructions,
  );

  /// Narración de "Rotación".
  String rotationNarration(AppLocalizations l10n) {
    final current = currentPractice;
    return l10n.rotationNarration(
      data.soilHealth.condition.label(l10n).toLowerCase(),
      current.consecutiveCampaigns,
      current.mainCrop.name.toLowerCase(),
      comparedOptionsCount,
      current.name(l10n).toLowerCase(),
      current.soilInTwoYears.label(l10n).toLowerCase(),
      best.name(l10n).toLowerCase(),
    );
  }

  /// Lo que siembra hoy + hasta dos alternativas.
  int get comparedOptionsCount => 1 + comparedRotations.length;

  /// Las dos mejores opciones según la prioridad.
  List<RotationOption> get comparedRotations => rankedOptions.take(2).toList();
}
