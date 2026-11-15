import 'package:flutter/foundation.dart';
import 'package:siembra_segura/core/l10n/app_language.dart';
import 'package:siembra_segura/shared/data/mock_text_translations.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';

/// Traduce los textos de los datos de ejemplo (repositorios mock).
///
/// Los datos de ejemplo se escriben en español y se traducen con una tabla
/// ([mockTextsEn], [mockTextsQu]). Con datos reales, estos textos los manda
/// el backend ya en el idioma pedido (ver `docs/ARCHITECTURE.md`, B15).
///
/// Lo que no está en la tabla se queda en español; en inglés se anota en
/// [missing] para que una prueba avise.
class MockText {
  /// Crea el traductor para [language].
  const MockText(this.language);

  /// Idioma de destino.
  final AppLanguage language;

  /// Textos en español sin traducción al inglés vistos hasta ahora.
  @visibleForTesting
  static final Set<String> missing = {};

  /// [spanish] en el idioma de destino.
  String call(String spanish) {
    switch (language) {
      case AppLanguage.spanish:
        return spanish;
      case AppLanguage.quechua:
        return mockTextsQu[spanish] ?? spanish;
      case AppLanguage.english:
        final english = mockTextsEn[spanish];
        if (english == null) missing.add(spanish);
        return english ?? spanish;
    }
  }

  /// El cultivo con su nombre traducido.
  Crop crop(Crop crop) => Crop(id: crop.id, name: call(crop.name));

  /// La prioridad con sus textos traducidos.
  CampaignPriority priority(CampaignPriority priority) => CampaignPriority(
    id: priority.id,
    name: call(priority.name),
    phrase: call(priority.phrase),
  );

  /// La restricción con su nombre traducido.
  CampaignRestriction restriction(CampaignRestriction restriction) =>
      CampaignRestriction(id: restriction.id, name: call(restriction.name));
}
