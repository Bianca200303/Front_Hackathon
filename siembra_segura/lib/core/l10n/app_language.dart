import 'dart:ui';

/// Idiomas de la app.
///
/// El quechua es un borrador: lo que aún no está traducido se muestra en
/// español (ver `docs/l10n_qu_pendientes.json`).
enum AppLanguage {
  /// Español (idioma base del proyecto).
  spanish('es'),

  /// Inglés.
  english('en'),

  /// Quechua (runasimi), borrador pendiente de revisión por hablantes.
  quechua('qu');

  const AppLanguage(this.code);

  /// Código ISO 639-1, el mismo de los archivos `app_<code>.arb`.
  final String code;

  /// `Locale` para `MaterialApp`.
  Locale get locale => Locale(code);

  /// Idioma con código [code], o `null` si la app no lo tiene. Acepta los
  /// códigos de tres letras de las variedades de quechua (`quz`, `quy`…).
  static AppLanguage? fromCode(String code) {
    final lower = code.toLowerCase();
    if (_isQuechua(lower)) return AppLanguage.quechua;
    for (final language in values) {
      if (language.code == lower) return language;
    }
    return null;
  }

  /// Elige el idioma a partir de los idiomas del celular, en orden de
  /// preferencia:
  ///
  /// 1. El primer idioma del celular que la app tenga.
  /// 2. Si ninguno, la región: en un país hispanohablante, español.
  /// 3. Si no, inglés.
  static AppLanguage resolve(List<Locale> deviceLocales) {
    for (final locale in deviceLocales) {
      final language = fromCode(locale.languageCode);
      if (language != null) return language;
    }
    for (final locale in deviceLocales) {
      if (_spanishSpeakingRegions.contains(locale.countryCode?.toUpperCase())) {
        return AppLanguage.spanish;
      }
    }
    return AppLanguage.english;
  }

  // ISO 639-3 agrupa las variedades de quechua en qu*, qv*, qw* y qx*.
  static bool _isQuechua(String code) =>
      code == 'qu' ||
      (code.length == 3 && const ['qu', 'qv', 'qw', 'qx'].any(code.startsWith));

  static const _spanishSpeakingRegions = {
    'AR', 'BO', 'CL', 'CO', 'CR', 'CU', 'DO', 'EC', 'ES', 'GQ', 'GT', //
    'HN', 'MX', 'NI', 'PA', 'PE', 'PR', 'PY', 'SV', 'UY', 'VE',
  };
}
