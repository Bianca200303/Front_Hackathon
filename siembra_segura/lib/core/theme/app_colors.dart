import 'package:flutter/painting.dart';

/// Par fondo/texto para píldoras, etiquetas y bloques con color.
class Tone {
  /// Crea el par de colores.
  const Tone(this.background, this.foreground);

  /// Color de fondo.
  final Color background;

  /// Color del texto o icono sobre [background].
  final Color foreground;
}

/// Paleta de la app, extraída de la referencia HTML (variables `:root`).
///
/// Es la única fuente de color: los widgets no definen colores sueltos.
/// La app no tiene modo oscuro en la referencia; si se incorpora, esta clase
/// se convierte en una `ThemeExtension`.
abstract final class AppColors {
  // Base
  /// Fondo general de las pantallas.
  static const background = Color(0xFFF5F6F1);

  /// Fondo de la pantalla de mensajes.
  static const chatBackground = Color(0xFFEEF0EA);

  /// Fondo de tarjetas.
  static const surface = Color(0xFFFFFFFF);

  /// Relleno de barras y medidores vacíos.
  static const surfaceMuted = Color(0xFFE6EAE1);

  /// Fondo sutil (días sin lluvia).
  static const surfaceSubtle = Color(0xFFF0F3EE);

  /// Fondo suave de elementos neutros.
  static const surfaceSoft = Color(0xFFEEF0EA);

  // Texto
  /// Texto principal y títulos.
  static const textPrimary = Color(0xFF17231C);

  /// Texto de párrafos.
  static const textBody = Color(0xFF2E3A32);

  /// Texto secundario (cumple contraste AA sobre [surface]).
  static const textMuted = Color(0xFF4B5A50);

  /// Texto e iconos sobre [primary].
  static const onPrimary = Color(0xFFFFFFFF);

  // Bordes
  /// Borde de tarjetas y controles.
  static const border = Color(0xFFDDE2D8);

  /// Borde de controles con más énfasis.
  static const borderStrong = Color(0xFFCBD2C6);

  // Marca
  /// Verde de marca: botones, selección, recomendado.
  static const primary = Color(0xFF1E5A3C);

  /// Verde oscuro para estados presionados.
  static const primaryDark = Color(0xFF123A26);

  /// Fondo verde suave (consejos).
  static const primarySoft = Color(0xFFEAF2EC);

  /// Anillo de foco para navegación por teclado.
  static const focus = Color(0xFFE9B949);

  // Semánticos
  /// Cifras positivas (ganancia).
  static const positive = Color(0xFF14532D);

  /// Cifras negativas (pérdida).
  static const negative = Color(0xFF8F1B13);

  /// Agua y lluvia.
  static const water = Color(0xFF1D4E89);

  /// Títulos de advertencia (pronóstico).
  static const amber = Color(0xFF8A4A05);

  /// Calor y sequía.
  static const heat = Color(0xFFD99A1E);

  /// Punto de avisos nuevos.
  static const notificationBadge = Color(0xFFC2410C);

  // Tonos (fondo, texto)
  /// Advertencias.
  static const warningTone = Tone(Color(0xFFFFF4E5), Color(0xFF5C3203));

  /// Borde de las advertencias.
  static const warningBorder = Color(0xFFF0C88A);

  /// Lluvia.
  static const waterTone = Tone(Color(0xFFE3ECF7), water);

  /// Lluvia fuerte.
  static const waterStrongTone = Tone(Color(0xFFC9DAF0), water);

  /// Calor.
  static const heatTone = Tone(Color(0xFFFFF1DD), Color(0xFF7A3E00));

  /// Valores normales.
  static const normalTone = Tone(Color(0xFFE3F1E8), positive);

  /// Tierra (también color de cultivo en la paleta).
  static const soilTone = Tone(Color(0xFFE9E2D3), Color(0xFF5A4520));

  /// Advertencia en ámbar.
  static const amberTone = Tone(Color(0xFFFFF1DD), amber);

  /// Elementos neutros.
  static const neutralTone = Tone(surfaceSoft, textMuted);

  /// Recuadro de consejo.
  static const adviceTone = Tone(primarySoft, positive);

  // Estado de la tierra
  /// Tierra en buen estado.
  static const soilGoodTone = Tone(Color(0xFFE3F1E8), positive);

  /// Tierra regular.
  static const soilRegularTone = Tone(Color(0xFFFFF1DD), Color(0xFF7A3E00));

  /// Tierra cansada.
  static const soilTiredTone = Tone(Color(0xFFFDE7DD), Color(0xFF8A2C06));

  /// Tierra muy cansada.
  static const soilVeryTiredTone = Tone(Color(0xFFF9D5C7), Color(0xFF6E1F00));

  /// Medidor de tierra: segmento bajo.
  static const soilGaugeLow = Color(0xFFC2410C);

  /// Medidor de tierra: segmento medio.
  static const soilGaugeMid = heat;

  /// Medidor de tierra: segmento alto.
  static const soilGaugeHigh = Color(0xFF2E8B57);

  // Ilustraciones (mapa de la parcela, audio)

  /// Campos vecinos del mapa ilustrado.
  static const mapField = Color(0xFFD4DFC9);

  /// Caminos del mapa ilustrado.
  static const mapRoad = Color(0xFFC1CFB4);

  /// Canal de riego del mapa ilustrado.
  static const mapCanal = Color(0xFF9FB7D1);

  /// Parcelas vecinas del mapa ilustrado.
  static const mapPlot = Color(0xFFC9D8BC);

  /// Barras de la onda de audio aún no reproducidas.
  static const waveformPending = Color(0xFFA9B8AD);

  // Cultivos

  /// Paleta para identificar cultivos. A cada cultivo le toca un color
  /// estable según su identificador (ver `CropTone`). Son los colores de la
  /// referencia; el orden hace que los cultivos de ejemplo conserven el
  /// color que tenían en el HTML.
  static const cropPalette = <Tone>[
    Tone(Color(0xFFC9CCD6), Color(0xFF22252E)), // gris (algodón)
    Tone(Color(0xFF8BB37C), Color(0xFF14321E)), // verde (frejol)
    Tone(Color(0xFFD8CBA8), Color(0xFF3A2F12)), // beige (arroz)
    soilTone, // tierra (menestra)
    Tone(Color(0xFFE9B949), Color(0xFF3D2A00)), // amarillo (maíz)
  ];

  /// Verde de la barra de probabilidad del escenario "normal".
  static const scenarioNormal = Color(0xFF8BB37C);
}
