/// Textos y colores del vocabulario compartido.
///
/// - Los catálogos abiertos (cultivos, prioridades, restricciones) ya traen
///   su nombre desde los datos; aquí solo se les asigna color.
/// - Las escalas cerradas (escenarios, estado del suelo) se traducen con
///   `switch` exhaustivos: si se agrega un valor, el compilador obliga a
///   darle texto y color.
library;

import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/theme/app_colors.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';

/// Color de un cultivo.
extension CropTone on Crop {
  /// Color estable derivado del identificador del cultivo.
  ///
  /// El mismo cultivo tiene siempre el mismo color en todas las pantallas,
  /// sin que la app conozca la lista de cultivos. Si producto quiere un
  /// color fijo por cultivo, el backend debería enviarlo (decisión B13).
  Tone get tone =>
      AppColors.cropPalette[_stableHash(id) % AppColors.cropPalette.length];

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
  Tone get tone => switch (this) {
    SoilCondition.veryTired => AppColors.soilVeryTiredTone,
    SoilCondition.tired => AppColors.soilTiredTone,
    SoilCondition.regular => AppColors.soilRegularTone,
    SoilCondition.good => AppColors.soilGoodTone,
  };
}
