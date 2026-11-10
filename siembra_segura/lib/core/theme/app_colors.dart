import 'package:flutter/painting.dart';

/// Par fondo/texto para píldoras, etiquetas y bloques con color.
class Tone {
  const Tone(this.background, this.foreground);

  final Color background;
  final Color foreground;
}

/// Paleta de la app, extraída de la referencia HTML (variables `:root`).
///
/// Es la única fuente de color: los widgets no definen colores sueltos.
/// La app no tiene modo oscuro en la referencia; si se incorpora, esta clase
/// se convierte en una `ThemeExtension`.
abstract final class AppColors {
  // Base
  static const background = Color(0xFFF5F6F1);
  static const chatBackground = Color(0xFFEEF0EA);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceMuted = Color(0xFFE6EAE1);
  static const surfaceSubtle = Color(0xFFF0F3EE);
  static const surfaceSoft = Color(0xFFEEF0EA);

  // Texto
  static const textPrimary = Color(0xFF17231C);
  static const textBody = Color(0xFF2E3A32);
  static const textMuted = Color(0xFF4B5A50);
  static const onPrimary = Color(0xFFFFFFFF);

  // Bordes
  static const border = Color(0xFFDDE2D8);
  static const borderStrong = Color(0xFFCBD2C6);

  // Marca
  static const primary = Color(0xFF1E5A3C);
  static const primaryDark = Color(0xFF123A26);
  static const primarySoft = Color(0xFFEAF2EC);
  static const focus = Color(0xFFE9B949);

  // Semánticos
  static const positive = Color(0xFF14532D);
  static const negative = Color(0xFF8F1B13);
  static const water = Color(0xFF1D4E89);
  static const amber = Color(0xFF8A4A05);
  static const heat = Color(0xFFD99A1E);
  static const notificationBadge = Color(0xFFC2410C);

  // Tonos (fondo, texto)
  static const warningTone = Tone(Color(0xFFFFF4E5), Color(0xFF5C3203));
  static const warningBorder = Color(0xFFF0C88A);
  static const waterTone = Tone(Color(0xFFE3ECF7), water);
  static const waterStrongTone = Tone(Color(0xFFC9DAF0), water);
  static const heatTone = Tone(Color(0xFFFFF1DD), Color(0xFF7A3E00));
  static const normalTone = Tone(Color(0xFFE3F1E8), positive);
  static const soilTone = Tone(Color(0xFFE9E2D3), Color(0xFF5A4520));
  static const amberTone = Tone(Color(0xFFFFF1DD), amber);
  static const neutralTone = Tone(surfaceSoft, textMuted);
  static const adviceTone = Tone(primarySoft, positive);

  // Estado de la tierra
  static const soilGoodTone = Tone(Color(0xFFE3F1E8), positive);
  static const soilRegularTone = Tone(Color(0xFFFFF1DD), Color(0xFF7A3E00));
  static const soilTiredTone = Tone(Color(0xFFFDE7DD), Color(0xFF8A2C06));
  static const soilVeryTiredTone = Tone(Color(0xFFF9D5C7), Color(0xFF6E1F00));
  static const soilGaugeLow = Color(0xFFC2410C);
  static const soilGaugeMid = heat;
  static const soilGaugeHigh = Color(0xFF2E8B57);

  // Cultivos
  static const maizeTone = Tone(Color(0xFFE9B949), Color(0xFF3D2A00));
  static const beanTone = Tone(Color(0xFF8BB37C), Color(0xFF14321E));
  static const cottonTone = Tone(Color(0xFFC9CCD6), Color(0xFF22252E));
  static const riceTone = Tone(Color(0xFFD8CBA8), Color(0xFF3A2F12));
  static const otherCropTone = neutralTone;
}
