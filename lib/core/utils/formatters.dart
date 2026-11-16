import 'package:intl/intl.dart';
import 'package:siembra_segura/core/l10n/app_language.dart';

/// Formatos numéricos y de fecha. Centralizados para no repetir lógica de
/// presentación en los widgets.
///
/// Siguen el idioma de la app ([useLanguage], lo llama `SiembraSeguraApp`).
/// `intl` no tiene nombres de días ni meses en quechua: con quechua se usan
/// los de español, como es habitual en el habla bilingüe.
///
/// Las funciones de fecha requieren `initializeDateFormatting()` (lo hace
/// `main.dart`; en tests, el helper de pruebas).
abstract final class AppFormatters {
  static AppLanguage _language = AppLanguage.spanish;

  /// Idioma en uso para fechas.
  static AppLanguage get language => _language;

  /// Cambia el idioma de las fechas.
  static void useLanguage(AppLanguage language) => _language = language;

  static String get _locale => _language == AppLanguage.english ? 'en' : 'es';

  /// En Perú las cifras se agrupan con coma (`15,600 m³`), como en la
  /// referencia. Los datos de `intl` para `es_PE` usan punto, así que se
  /// fija explícitamente el patrón de agrupación.
  static final NumberFormat _integer = NumberFormat('#,##0', 'en_US');
  static final NumberFormat _decimal = NumberFormat('#,##0.#', 'en_US');
  static final NumberFormat _coordinate = NumberFormat('0.0000', 'en_US');

  /// `7800` → `7,800 m³`
  static String cubicMeters(num volume) => '${_integer.format(volume)} m³';

  /// `0.7` → `70%`
  static String percent(double ratio) => '${(ratio * 100).round()}%';

  /// `12` → `12 mm`
  static String millimeters(num value) => '${_integer.format(value)} mm';

  /// `31` → `31 °C`
  static String celsius(num value) => '${_integer.format(value)} °C';

  /// `3.2` → `3.2`, `3.0` → `3`
  static String decimal(num value) => _decimal.format(value);

  /// `-5.19` → `-5.1900`. Cuatro decimales: ~10 m, suficiente para una
  /// chacra y para pedir los datos satelitales del punto.
  static String coordinate(double degrees) => _coordinate.format(degrees);

  /// Domingo → `domingo`
  static String weekday(DateTime date) =>
      DateFormat('EEEE', _locale).format(date);

  /// Domingo → `Dom`
  static String shortWeekday(DateTime date) =>
      _capitalize(_stripDot(DateFormat('EEE', _locale).format(date)));

  /// Diciembre → `diciembre`
  static String monthName(DateTime date) =>
      DateFormat('MMMM', _locale).format(date);

  /// Diciembre → `Dic`
  static String shortMonth(DateTime date) =>
      _capitalize(_stripDot(DateFormat('MMM', _locale).format(date)));

  /// `15 de diciembre` / `December 15`
  static String dayAndMonth(DateTime date) => DateFormat(
    _language == AppLanguage.english ? 'MMMM d' : "d 'de' MMMM",
    _locale,
  ).format(date);

  /// Espacio no separable: evita que "a. m." se parta entre líneas.
  static final String nonBreakingSpace = String.fromCharCode(0x00A0);
  static final String _narrowNonBreakingSpace = String.fromCharCode(0x202F);

  /// `6:00 a. m.` (con espacio no separable entre "a." y "m.").
  ///
  /// Según quién haya cargado los datos de fecha (`intl` o
  /// `flutter_localizations`), el separador es U+202F o U+00A0; se
  /// normaliza a U+00A0 para que el resultado no dependa del entorno.
  static String time(DateTime date) => DateFormat(
    'h:mm a',
    _locale,
  ).format(date).replaceAll(_narrowNonBreakingSpace, nonBreakingSpace);

  /// Primera letra en mayúscula ("el miércoles" → "El miércoles").
  static String capitalize(String text) => _capitalize(text);

  /// Primera letra en minúscula, para insertar textos dentro de una frase.
  static String lowercaseFirst(String text) =>
      text.isEmpty ? text : text[0].toLowerCase() + text.substring(1);

  static String _capitalize(String text) =>
      text.isEmpty ? text : text[0].toUpperCase() + text.substring(1);

  static String _stripDot(String text) =>
      text.endsWith('.') ? text.substring(0, text.length - 1) : text;
}
