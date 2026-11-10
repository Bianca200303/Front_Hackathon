import 'package:flutter/widgets.dart';

/// Escala de espaciado, radios y tamaños mínimos.
abstract final class AppSpacing {
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;

  /// Margen horizontal de las pantallas.
  static const double screenGutter = xl;

  /// Separación vertical entre bloques de una pantalla.
  static const double sectionGap = 14;

  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: screenGutter,
  );
}

abstract final class AppRadii {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 14;
  static const double xl = 16;
  static const double pill = 999;

  static const BorderRadius card = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius button = BorderRadius.all(Radius.circular(lg));
}

abstract final class AppSizes {
  /// Mínimo táctil de Material (la referencia usaba 44 px).
  static const double minTouchTarget = 48;
  static const double primaryButtonHeight = 56;
  static const double compactButtonHeight = 48;

  /// Ancho máximo del contenido; en tablets se centra.
  static const double maxContentWidth = 600;
}
