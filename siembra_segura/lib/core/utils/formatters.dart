import 'package:intl/intl.dart';

/// Formatos numéricos para Perú. Centralizados para no repetir lógica
/// de presentación en los widgets.
abstract final class AppFormatters {
  /// En Perú las cifras se agrupan con coma (`S/ 2,400`), como en la
  /// referencia. Los datos de `intl` para `es_PE` usan punto, así que se
  /// fijan explícitamente los símbolos de agrupación.
  static final NumberFormat _integer = NumberFormat('#,##0', 'en_US');

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
}
