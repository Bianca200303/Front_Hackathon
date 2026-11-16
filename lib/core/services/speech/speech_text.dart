import 'package:siembra_segura/core/l10n/app_language.dart';

/// Prepara un texto de pantalla para leerlo en voz alta: cambia símbolos y
/// abreviaturas por palabras, para que la voz no diga "ese barra" o "jota".
abstract final class SpeechText {
  // Un número empieza y termina en dígito: "5,000." no se lleva el punto.
  static const _number = r'(\d(?:[\d.,]*\d)?)';
  static final _soles = RegExp(r'S/\.?\s*' + _number);
  static final _degrees = RegExp(_number + r'\s*°\s*C\b');
  static final _millimeters = RegExp(_number + r'\s*mm\b');
  static final _kilos = RegExp(_number + r'\s*kg\b');
  static final _hectares = RegExp(_number + r'\s*ha\b');
  static final _percent = RegExp(_number + r'\s*%');
  static final _markdown = RegExp(r'\*\*|__|`');
  static final _separators = RegExp(r'\s*[·•|→]\s*');
  static final _spaces = RegExp(r'\s{2,}');

  /// Devuelve [text] listo para la voz en [language]. Con quechua se usan
  /// las palabras en español: es la voz que lo lee (no hay voz quechua).
  static String normalize(
    String text, [
    AppLanguage language = AppLanguage.spanish,
  ]) {
    final units = language == AppLanguage.english ? _english : _spanish;
    return text
        .replaceAll(_markdown, '')
        .replaceAllMapped(_soles, (m) => '${m[1]} ${units.soles}')
        .replaceAllMapped(_degrees, (m) => '${m[1]} ${units.degrees}')
        .replaceAllMapped(_millimeters, (m) => '${m[1]} ${units.millimeters}')
        .replaceAllMapped(_kilos, (m) => '${m[1]} ${units.kilos}')
        .replaceAllMapped(_hectares, (m) => '${m[1]} ${units.hectares}')
        .replaceAllMapped(_percent, (m) => '${m[1]} ${units.percent}')
        // Una pausa corta donde la pantalla separa datos con "·".
        .replaceAll(_separators, ', ')
        .replaceAll(_spaces, ' ')
        .trim();
  }

  static const _spanish = (
    soles: 'soles',
    degrees: 'grados',
    millimeters: 'milímetros',
    kilos: 'kilos',
    hectares: 'hectáreas',
    percent: 'por ciento',
  );

  static const _english = (
    soles: 'soles',
    degrees: 'degrees',
    millimeters: 'millimeters',
    kilos: 'kilograms',
    hectares: 'hectares',
    percent: 'percent',
  );
}
