import 'package:intl/intl.dart';

/// Formatos numéricos y de fecha para Perú. Centralizados para no repetir
/// lógica de presentación en los widgets.
///
/// Las funciones de fecha requieren `initializeDateFormatting('es')`
/// (lo hace `main.dart`; en tests, el helper de pruebas).
abstract final class AppFormatters {
  static const _locale = 'es';

  /// En Perú las cifras se agrupan con coma (`S/ 2,400`), como en la
  /// referencia. Los datos de `intl` para `es_PE` usan punto, así que se
  /// fijan explícitamente los símbolos de agrupación.
  static final NumberFormat _integer = NumberFormat('#,##0', 'en_US');
  static final NumberFormat _decimal = NumberFormat('#,##0.#', 'en_US');

  /// `2400` → `S/ 2,400`
  static String soles(num amount) => 'S/ ${_integer.format(amount)}';

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

  /// `15 de diciembre`
  static String dayAndMonth(DateTime date) =>
      DateFormat("d 'de' MMMM", _locale).format(date);

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
