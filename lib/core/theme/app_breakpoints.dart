/// Puntos de corte de diseño adaptable, alineados con las clases de tamaño
/// de ventana de Material 3.
///
/// | Ancho de ventana | Clase     | Navegación      | Contenido           |
/// |------------------|-----------|-----------------|---------------------|
/// | < 600 dp         | compacta  | barra inferior  | 1 columna           |
/// | 600–839 dp       | mediana   | riel lateral    | 1 columna centrada  |
/// | ≥ 840 dp         | expandida | riel lateral    | hasta 2 columnas    |
///
/// Un teléfono en horizontal suele caer en "mediana": el riel lateral
/// libera el alto que ocuparía la barra inferior.
abstract final class AppBreakpoints {
  /// Desde este ancho de ventana se usa el riel lateral.
  static const double medium = 600;

  /// Desde este ancho de ventana el riel muestra el logo y más aire.
  static const double expanded = 840;

  /// Ancho de **contenido** desde el que dos tarjetas caben lado a lado
  /// sin apretar el texto.
  static const double twoColumnContent = 720;

  /// `true` si la ventana usa navegación lateral.
  static bool usesNavigationRail(double windowWidth) => windowWidth >= medium;
}
