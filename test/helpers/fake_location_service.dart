import 'package:siembra_segura/core/services/location/device_location.dart';

/// Ubicación del celular para las pruebas: devuelve [result] y cuenta las
/// veces que se pidió.
class FakeLocationService implements DeviceLocationService {
  FakeLocationService([this.result = const LocationUnavailable()]);

  /// Lo que "dice" el GPS.
  DeviceLocationResult result;

  /// Cuántas veces se pidió la ubicación.
  int requests = 0;

  @override
  Future<DeviceLocationResult> current() async {
    requests++;
    return result;
  }
}
