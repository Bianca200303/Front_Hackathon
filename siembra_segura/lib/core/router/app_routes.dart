/// Rutas de la app. Es la única fuente de paths: ningún widget escribe
/// rutas como texto suelto.
///
/// Vive en `core` (sin dependencias de features) para que los features
/// puedan navegar sin importar la composición del router.
abstract final class AppRoutes {
  static const farm = '/parcela';

  // Pestañas
  static const climate = '/clima';
  static const recommendation = '/que-sembrar';
  static const rotation = '/rotacion';
  static const alerts = '/avisos';

  // Pantallas completas (sin barra de pestañas)
  static const plantingSchedule = '$recommendation/cuando-sembrar';
  static const alertDetailPattern = '$alerts/:${Params.alertId}';
  static String alertDetail(String alertId) =>
      '$alerts/${Uri.encodeComponent(alertId)}';
}

abstract final class Params {
  static const alertId = 'alertId';
}
