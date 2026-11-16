import 'package:flutter/painting.dart';

/// Paleta de Semi, el personaje asistente. Sale de su ficha de diseño
/// (`Personaje bot – App de agricultura.html`).
///
/// Solo la usan el dibujo de Semi y sus burbujas; el resto de la app sigue
/// usando `AppColors`.
abstract final class SemiColors {
  // Cuerpo
  /// "Semilla": cuerpo.
  static const body = Color(0xFFD9A15B);

  /// Brazos.
  static const arm = Color(0xFFC08446);

  /// Sombra lateral del cuerpo.
  static const bodyShade = Color(0xFF9A6631);

  /// "Panza".
  static const belly = Color(0xFFF0CF98);

  /// Pies.
  static const feet = Color(0xFF7A4E2A);

  /// Sombra en el suelo y texto oscuro de Semi.
  static const ink = Color(0xFF173326);

  // Bufanda
  /// "Sol": bufanda.
  static const scarf = Color(0xFFF4B63F);

  /// Punta de la bufanda.
  static const scarfTail = Color(0xFFD99A26);

  // Cara
  /// "Visor": pantalla de la cara.
  static const visor = Color(0xFF3B2A1E);

  /// "Luz": ojos y boca.
  static const light = Color(0xFF8AF5C0);

  /// Ojos y boca en alerta.
  static const alertLight = Color(0xFFFFC857);

  /// Mejillas.
  static const cheek = Color(0xFFFF8FA3);

  /// Brillos.
  static const shine = Color(0xFFFFFFFF);

  // Brote
  /// Tallo del brote.
  static const sproutStem = Color(0xFF3F9B50);

  /// Hoja clara del brote.
  static const sproutLeafLight = Color(0xFF7ED36F);

  /// "Brote": hoja oscura.
  static const sproutLeafDark = Color(0xFF4FAE5C);

  // Extras de expresión
  /// Insignia de alerta.
  static const alertBadge = Color(0xFFE8833A);

  /// Gotas de lluvia al celebrar.
  static const raindrop = Color(0xFF6FB7E8);

  // El fondo de su tarjeta y su halo están en `AppPalette` (cambian con
  // el modo oscuro); Semi se ve igual en claro y oscuro.
}
