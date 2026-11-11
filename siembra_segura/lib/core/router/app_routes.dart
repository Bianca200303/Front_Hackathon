/// Rutas de la app. Es la única fuente de paths: ningún widget escribe
/// rutas como texto suelto.
///
/// Vive en `core` (sin dependencias de features) para que los features
/// puedan navegar sin importar la composición del router.
abstract final class AppRoutes {
  /// "Mi parcela": configuración de la campaña.
  static const farm = '/parcela';

  // Pestañas
  /// Pestaña Clima.
  static const climate = '/clima';

  /// Pestaña Qué sembrar.
  static const recommendation = '/que-sembrar';

  /// Pestaña Rotación.
  static const rotation = '/rotacion';

  /// Pestaña Avisos.
  static const alerts = '/avisos';

  // Pantallas completas (sin barra de pestañas)
  /// "¿Cuándo siembro?", encima de las pestañas.
  static const plantingSchedule = '$recommendation/cuando-sembrar';

  /// Patrón de ruta del mensaje de un aviso.
  static const alertDetailPattern = '$alerts/:${Params.alertId}';

  /// Ruta del mensaje del aviso [alertId].
  static String alertDetail(String alertId) =>
      '$alerts/${Uri.encodeComponent(alertId)}';
}

/// Nombres de los parámetros de ruta.
abstract final class Params {
  /// Identificador del aviso en [AppRoutes.alertDetailPattern].
  static const alertId = 'alertId';
}
