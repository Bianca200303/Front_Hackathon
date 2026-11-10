import 'package:flutter_test/flutter_test.dart';
import 'package:siembra_segura/core/utils/formatters.dart';

void main() {
  test('formatea soles como en la referencia', () {
    expect(AppFormatters.soles(2400), 'S/ 2,400');
    expect(AppFormatters.soles(300), 'S/ 300');
  });

  test('formatea unidades', () {
    expect(AppFormatters.cubicMeters(14500), '14,500 m³');
    expect(AppFormatters.percent(0.7), '70%');
    expect(AppFormatters.millimeters(40), '40 mm');
    expect(AppFormatters.celsius(31), '31 °C');
  });
}
