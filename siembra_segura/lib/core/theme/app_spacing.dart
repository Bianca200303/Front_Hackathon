import 'package:flutter/widgets.dart';

/// Escala de espaciado, radios y tamaños mínimos.
abstract final class AppSpacing {
  /// 2 dp.
  static const double xxs = 2;

  /// 4 dp.
  static const double xs = 4;

  /// 8 dp.
  static const double sm = 8;

  /// 12 dp.
  static const double md = 12;

  /// 16 dp.
  static const double lg = 16;

  /// 20 dp.
  static const double xl = 20;

  /// 24 dp.
  static const double xxl = 24;

  /// Margen horizontal de las pantallas.
  static const double screenGutter = xl;

  /// Separación vertical entre bloques de una pantalla.
  static const double sectionGap = 14;

  /// Margen horizontal estándar de pantalla.
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: screenGutter,
  );
}

/// Radios de borde.
abstract final class AppRadii {
  /// Radio pequeño (bloques, etiquetas).
  static const double sm = 8;

  /// Radio mediano (controles).
  static const double md = 12;

  /// Radio de botones.
  static const double lg = 14;

  /// Radio de tarjetas.
  static const double xl = 16;

  /// Radio de píldora (bordes totalmente redondos).
  static const double pill = 999;

  /// Borde de tarjeta.
  static const BorderRadius card = BorderRadius.all(Radius.circular(xl));

  /// Borde de botón.
  static const BorderRadius button = BorderRadius.all(Radius.circular(lg));
}

/// Tamaños fijos de componentes.
abstract final class AppSizes {
  /// Mínimo táctil de Material (la referencia usaba 44 px).
  static const double minTouchTarget = 48;

  /// Alto del botón principal.
  static const double primaryButtonHeight = 56;

  /// Alto del botón compacto.
  static const double compactButtonHeight = 48;

  /// Ancho máximo del contenido de lectura; en tablets se centra.
  static const double maxContentWidth = 600;

  /// Ancho máximo de las pantallas con dos columnas (`ScreenLayout.wide`).
  static const double maxWideContentWidth = 1040;

  /// Espacio libre al final de las listas para que el botón "Ayuda" de
  /// Semi no tape el último contenido.
  static const double helpButtonClearance = 96;
}
