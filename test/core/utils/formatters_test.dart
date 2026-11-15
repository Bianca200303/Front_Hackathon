import 'package:flutter_test/flutter_test.dart';
import 'package:siembra_segura/core/utils/formatters.dart';

import '../../helpers/pump_app.dart';

void main() {
  setUpAll(initTestLocale);

  // Los miles se agrupan con coma, como en la referencia (decisión 11).
  test('formatea unidades', () {
    expect(AppFormatters.cubicMeters(15600), '15,600 m³');
    expect(AppFormatters.cubicMeters(300), '300 m³');
    expect(AppFormatters.percent(0.7), '70%');
    expect(AppFormatters.millimeters(40), '40 mm');
    expect(AppFormatters.celsius(31), '31 °C');
    expect(AppFormatters.decimal(3.2), '3.2');
    expect(AppFormatters.decimal(3), '3');
  });

  test('formatea fechas en español', () {
    final sunday = DateTime(2026, 11, 8, 6);
    final december = DateTime(2026, 12, 15);

    expect(AppFormatters.weekday(sunday), 'domingo');
    expect(AppFormatters.shortWeekday(sunday), 'Dom');
    expect(AppFormatters.shortWeekday(DateTime(2026, 11, 11)), 'Mié');
    expect(AppFormatters.monthName(december), 'diciembre');
    expect(AppFormatters.shortMonth(december), 'Dic');
    expect(AppFormatters.dayAndMonth(december), '15 de diciembre');
    expect(
      AppFormatters.time(sunday),
      '6:00 a.${AppFormatters.nonBreakingSpace}m.',
    );
  });

  test('ajusta mayúsculas', () {
    expect(AppFormatters.capitalize('febrero'), 'Febrero');
    expect(AppFormatters.lowercaseFirst('El frejol'), 'el frejol');
    expect(AppFormatters.capitalize(''), '');
  });
}
