/// Textos y colores del vocabulario compartido.
///
/// - Los catálogos abiertos (cultivos, prioridades, restricciones) ya traen
///   su nombre desde los datos; aquí solo se les asigna color.
/// - Las escalas cerradas (escenarios, estado del suelo) se traducen con
///   `switch` exhaustivos: si se agrega un valor, el compilador obliga a
///   darle texto y color.
library;

import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/theme/app_palette.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';

/// Color de un cultivo.
extension CropTone on Crop {
  /// Color estable derivado del identificador del cultivo.
  ///
  /// El mismo cultivo tiene siempre el mismo color en todas las pantallas,
  /// sin que la app conozca la lista de cultivos. Si producto quiere un
  /// color fijo por cultivo, el backend debería enviarlo (decisión B13).
  Tone tone(AppPalette colors) {
    // Los cultivos de `semi_app.html` tienen su color fijo; uno nuevo toma
    // uno estable según su identificador.
    final known = _knownIndex[id];
    final palette = colors.cropPalette;
    return palette[(known ?? _stableHash(id)) % palette.length];
  }

  static const _knownIndex = {
    'rice': 0,
    'maize': 1,
    'bean': 2,
    'cotton': 3,
    'pulse': 4,
    'green-manure': 5,
  };

  /// FNV-1a de 32 bits: estable entre ejecuciones y plataformas, a
  /// diferencia de `String.hashCode`.
  static int _stableHash(String value) {
    var hash = 0x811c9dc5;
    for (final unit in value.codeUnits) {
      hash = ((hash ^ unit) * 0x01000193) & 0xffffffff;
    }
    return hash;
  }
}

/// Textos de la ficha de un cultivo.
extension CropWaterNeedLabels on CropWaterNeed {
  /// Cuánta agua pide ("Mucha agua").
  String label(AppLocalizations l10n) => switch (this) {
    CropWaterNeed.low => l10n.cropWaterNeedLow,
    CropWaterNeed.medium => l10n.cropWaterNeedMedium,
    CropWaterNeed.high => l10n.cropWaterNeedHigh,
  };
}

/// Ficha corta de un cultivo: agua, duración y si abona la tierra.
///
/// Devuelve solo lo que la fuente de datos sabe, en ese orden.
List<String> cropFacts(Crop crop, AppLocalizations l10n) => [
  if (crop.waterNeed case final need?) need.label(l10n),
  if (crop.cycleMonths case final months?) l10n.cropCycleMonths(months),
  if (crop.fixesNitrogen) l10n.cropFixesNitrogen,
];

/// Nombre de una secuencia de cultivos: "Maíz y después frejol" o, si se
/// repite, "Arroz y arroz".
String cropSequenceName(List<Crop> crops, AppLocalizations l10n) {
  if (crops.isEmpty) return '';
  final first = crops.first.name;
  if (crops.length == 1) return first;
  final second = crops[1].name.toLowerCase();
  return crops[0] == crops[1]
      ? l10n.rotationNameRepeated(first, second)
      : l10n.rotationNameSequence(first, second);
}

/// Une una lista con comas y "y": "maíz, frejol y algodón".
String joinWithAnd(List<String> items, AppLocalizations l10n) {
  if (items.isEmpty) return '';
  if (items.length == 1) return items.single;
  final head = items.sublist(0, items.length - 1).join(', ');
  return l10n.listJoin(head, items.last);
}

/// Textos de un escenario climático.
extension ClimateScenarioLabels on ClimateScenario {
  /// Nombre corto ("Lluvias fuertes").
  String label(AppLocalizations l10n) => switch (this) {
    ClimateScenario.heavyRains => l10n.scenarioHeavyRains,
    ClimateScenario.normal => l10n.scenarioNormal,
    ClimateScenario.dry => l10n.scenarioDry,
  };

  /// Texto del selector de escenarios.
  String optionLabel(AppLocalizations l10n) => switch (this) {
    ClimateScenario.heavyRains => l10n.scenarioOptionHeavyRains,
    ClimateScenario.normal => l10n.scenarioNormal,
    ClimateScenario.dry => l10n.scenarioDry,
  };

  /// Forma para insertar en frases ("si llueve fuerte").
  String phrase(AppLocalizations l10n) => switch (this) {
    ClimateScenario.heavyRains => l10n.scenarioPhraseHeavyRains,
    ClimateScenario.normal => l10n.scenarioPhraseNormal,
    ClimateScenario.dry => l10n.scenarioPhraseDry,
  };
}

/// Texto y color del riesgo de clima.
extension ClimateRiskLabels on ClimateRisk {
  /// Nombre del nivel ("Alto").
  String label(AppLocalizations l10n) => switch (this) {
    ClimateRisk.low => l10n.climateRiskLow,
    ClimateRisk.medium => l10n.climateRiskMedium,
    ClimateRisk.high => l10n.climateRiskHigh,
  };

  /// Color asociado, de verde (bajo) a rojo (alto).
  Tone tone(AppPalette colors) => switch (this) {
    ClimateRisk.low => colors.normalTone,
    ClimateRisk.medium => colors.warningTone,
    ClimateRisk.high => colors.soilTiredTone,
  };
}

/// Texto y color del estado de la tierra.
extension SoilConditionLabels on SoilCondition {
  /// Nombre del estado ("Cansada").
  String label(AppLocalizations l10n) => switch (this) {
    SoilCondition.veryTired => l10n.soilVeryTired,
    SoilCondition.tired => l10n.soilTired,
    SoilCondition.regular => l10n.soilRegular,
    SoilCondition.good => l10n.soilGood,
  };

  /// Color asociado, de rojo (peor) a verde (mejor).
  Tone tone(AppPalette colors) => switch (this) {
    SoilCondition.veryTired => colors.soilVeryTiredTone,
    SoilCondition.tired => colors.soilTiredTone,
    SoilCondition.regular => colors.soilRegularTone,
    SoilCondition.good => colors.soilGoodTone,
  };
}
