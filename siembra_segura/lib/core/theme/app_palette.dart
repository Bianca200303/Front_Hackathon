import 'package:flutter/material.dart';

/// Par fondo/texto para píldoras, etiquetas y bloques con color.
@immutable
class Tone {
  /// Crea el par de colores.
  const Tone(this.background, this.foreground);

  /// Color de fondo.
  final Color background;

  /// Color del texto o icono sobre [background].
  final Color foreground;
}

/// Paleta de la app, en claro ([light], la de la referencia HTML) y oscuro
/// ([dark], la de `semi_app.html`). Es la única fuente de color: los widgets
/// no definen colores sueltos y la leen con `context.colors`.
///
/// En oscuro, los colores de marca (verde, agua, ámbar) pasan a tonos claros
/// con texto oscuro encima, como recomienda Material 3, para mantener el
/// contraste AA tanto de rellenos como de textos.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  /// Crea la paleta. En la app se usan [light] y [dark].
  const AppPalette({
    required this.brightness,
    required this.background,
    required this.chatBackground,
    required this.surface,
    required this.surfaceMuted,
    required this.surfaceSubtle,
    required this.surfaceSoft,
    required this.textPrimary,
    required this.textBody,
    required this.textMuted,
    required this.onPrimary,
    required this.border,
    required this.borderStrong,
    required this.primary,
    required this.primaryDark,
    required this.primarySoft,
    required this.focus,
    required this.positive,
    required this.negative,
    required this.water,
    required this.amber,
    required this.heat,
    required this.notificationBadge,
    required this.warningTone,
    required this.warningBorder,
    required this.waterTone,
    required this.waterStrongTone,
    required this.heatTone,
    required this.normalTone,
    required this.soilTone,
    required this.amberTone,
    required this.neutralTone,
    required this.adviceTone,
    required this.soilGoodTone,
    required this.soilRegularTone,
    required this.soilTiredTone,
    required this.soilVeryTiredTone,
    required this.soilGaugeLow,
    required this.soilGaugeMid,
    required this.soilGaugeHigh,
    required this.mapField,
    required this.mapRoad,
    required this.mapCanal,
    required this.mapPlot,
    required this.waveformPending,
    required this.cropPalette,
    required this.scenarioNormal,
    required this.semiGuideBackground,
    required this.semiGuideBorder,
    required this.semiHalo,
  });

  /// Claro o oscuro.
  final Brightness brightness;

  /// Fondo general de las pantallas.
  final Color background;

  /// Fondo de la pantalla de mensajes.
  final Color chatBackground;

  /// Fondo de tarjetas.
  final Color surface;

  /// Relleno de barras y medidores vacíos.
  final Color surfaceMuted;

  /// Fondo sutil (días sin lluvia).
  final Color surfaceSubtle;

  /// Fondo suave de elementos neutros.
  final Color surfaceSoft;

  /// Texto principal y títulos.
  final Color textPrimary;

  /// Texto de párrafos.
  final Color textBody;

  /// Texto secundario (cumple contraste AA sobre [surface]).
  final Color textMuted;

  /// Texto e iconos sobre [primary] (y sobre [water] como relleno).
  final Color onPrimary;

  /// Borde de tarjetas y controles.
  final Color border;

  /// Borde de controles con más énfasis.
  final Color borderStrong;

  /// Verde de marca: botones, selección, recomendado.
  final Color primary;

  /// Verde para estados presionados y texto sobre [primarySoft].
  final Color primaryDark;

  /// Fondo verde suave (consejos).
  final Color primarySoft;

  /// Anillo de foco para navegación por teclado.
  final Color focus;

  /// Cifras buenas (cosecha esperada).
  final Color positive;

  /// Cifras malas (cosecha en un mal año).
  final Color negative;

  /// Agua y lluvia.
  final Color water;

  /// Títulos de advertencia (pronóstico).
  final Color amber;

  /// Calor y sequía.
  final Color heat;

  /// Punto de avisos nuevos.
  final Color notificationBadge;

  /// Advertencias.
  final Tone warningTone;

  /// Borde de las advertencias.
  final Color warningBorder;

  /// Lluvia.
  final Tone waterTone;

  /// Lluvia fuerte.
  final Tone waterStrongTone;

  /// Calor.
  final Tone heatTone;

  /// Valores normales.
  final Tone normalTone;

  /// Tierra.
  final Tone soilTone;

  /// Advertencia en ámbar.
  final Tone amberTone;

  /// Elementos neutros.
  final Tone neutralTone;

  /// Recuadro de consejo.
  final Tone adviceTone;

  /// Tierra en buen estado.
  final Tone soilGoodTone;

  /// Tierra regular.
  final Tone soilRegularTone;

  /// Tierra cansada.
  final Tone soilTiredTone;

  /// Tierra muy cansada.
  final Tone soilVeryTiredTone;

  /// Medidor de tierra: segmento bajo.
  final Color soilGaugeLow;

  /// Medidor de tierra: segmento medio.
  final Color soilGaugeMid;

  /// Medidor de tierra: segmento alto.
  final Color soilGaugeHigh;

  /// Campos vecinos del mapa ilustrado.
  final Color mapField;

  /// Caminos del mapa ilustrado.
  final Color mapRoad;

  /// Canal de riego del mapa ilustrado.
  final Color mapCanal;

  /// Parcelas vecinas del mapa ilustrado.
  final Color mapPlot;

  /// Barras de la onda de audio aún no reproducidas.
  final Color waveformPending;

  /// Paleta para identificar cultivos. A cada cultivo le toca un color
  /// estable según su identificador (ver `CropTone`). Son los colores de la
  /// referencia; el orden hace que los cultivos de ejemplo conserven el
  /// color que tenían en el HTML. Igual en claro y oscuro (como en
  /// `semi_app.html`): son franjas claras con texto oscuro.
  final List<Tone> cropPalette;

  /// Verde de la barra de probabilidad del escenario "normal".
  final Color scenarioNormal;

  /// Fondo del recuadro donde habla Semi.
  final Color semiGuideBackground;

  /// Borde del recuadro donde habla Semi.
  final Color semiGuideBorder;

  /// Círculo detrás de la cabeza de Semi.
  final Color semiHalo;

  static const _cropPalette = <Tone>[
    Tone(Color(0xFFC9CCD6), Color(0xFF22252E)), // gris (algodón)
    Tone(Color(0xFF8BB37C), Color(0xFF14321E)), // verde (frejol)
    Tone(Color(0xFFD8CBA8), Color(0xFF3A2F12)), // beige (arroz)
    Tone(Color(0xFFE9E2D3), Color(0xFF5A4520)), // tierra (menestra)
    Tone(Color(0xFFE9B949), Color(0xFF3D2A00)), // amarillo (maíz)
  ];

  /// Paleta clara (variables `:root` de la referencia).
  static const light = AppPalette(
    brightness: Brightness.light,
    background: Color(0xFFF5F6F1),
    chatBackground: Color(0xFFEEF0EA),
    surface: Color(0xFFFFFFFF),
    surfaceMuted: Color(0xFFE6EAE1),
    surfaceSubtle: Color(0xFFF0F3EE),
    surfaceSoft: Color(0xFFEEF0EA),
    textPrimary: Color(0xFF17231C),
    textBody: Color(0xFF2E3A32),
    textMuted: Color(0xFF4B5A50),
    onPrimary: Color(0xFFFFFFFF),
    border: Color(0xFFDDE2D8),
    borderStrong: Color(0xFFCBD2C6),
    primary: Color(0xFF1E5A3C),
    primaryDark: Color(0xFF123A26),
    primarySoft: Color(0xFFEAF2EC),
    focus: Color(0xFFE9B949),
    positive: Color(0xFF14532D),
    negative: Color(0xFF8F1B13),
    water: Color(0xFF1D4E89),
    amber: Color(0xFF8A4A05),
    heat: Color(0xFFD99A1E),
    notificationBadge: Color(0xFFC2410C),
    warningTone: Tone(Color(0xFFFFF4E5), Color(0xFF5C3203)),
    warningBorder: Color(0xFFF0C88A),
    waterTone: Tone(Color(0xFFE3ECF7), Color(0xFF1D4E89)),
    waterStrongTone: Tone(Color(0xFFC9DAF0), Color(0xFF1D4E89)),
    heatTone: Tone(Color(0xFFFFF1DD), Color(0xFF7A3E00)),
    normalTone: Tone(Color(0xFFE3F1E8), Color(0xFF14532D)),
    soilTone: Tone(Color(0xFFE9E2D3), Color(0xFF5A4520)),
    amberTone: Tone(Color(0xFFFFF1DD), Color(0xFF8A4A05)),
    neutralTone: Tone(Color(0xFFEEF0EA), Color(0xFF4B5A50)),
    adviceTone: Tone(Color(0xFFEAF2EC), Color(0xFF14532D)),
    soilGoodTone: Tone(Color(0xFFE3F1E8), Color(0xFF14532D)),
    soilRegularTone: Tone(Color(0xFFFFF1DD), Color(0xFF7A3E00)),
    soilTiredTone: Tone(Color(0xFFFDE7DD), Color(0xFF8A2C06)),
    soilVeryTiredTone: Tone(Color(0xFFF9D5C7), Color(0xFF6E1F00)),
    soilGaugeLow: Color(0xFFC2410C),
    soilGaugeMid: Color(0xFFD99A1E),
    soilGaugeHigh: Color(0xFF2E8B57),
    mapField: Color(0xFFD4DFC9),
    mapRoad: Color(0xFFC1CFB4),
    mapCanal: Color(0xFF9FB7D1),
    mapPlot: Color(0xFFC9D8BC),
    waveformPending: Color(0xFFA9B8AD),
    cropPalette: _cropPalette,
    scenarioNormal: Color(0xFF8BB37C),
    semiGuideBackground: Color(0xFFF4F8EE),
    semiGuideBorder: Color(0xFFB8D9A6),
    semiHalo: Color(0xFFE1F1D6),
  );

  /// Paleta oscura (variables `[data-tema="oscuro"]` de `semi_app.html`).
  static const dark = AppPalette(
    brightness: Brightness.dark,
    background: Color(0xFF111714),
    chatBackground: Color(0xFF0E1411),
    surface: Color(0xFF1A221D),
    surfaceMuted: Color(0xFF2C3830),
    surfaceSubtle: Color(0xFF1F2822),
    surfaceSoft: Color(0xFF212B24),
    textPrimary: Color(0xFFE9EFEA),
    textBody: Color(0xFFCAD4CD),
    textMuted: Color(0xFF9EABA2),
    onPrimary: Color(0xFF0B2014),
    border: Color(0xFF2C3830),
    borderStrong: Color(0xFF3B4840),
    primary: Color(0xFF7CC895),
    primaryDark: Color(0xFFA6DDB7),
    primarySoft: Color(0xFF1E3326),
    focus: Color(0xFFE9B949),
    positive: Color(0xFF7CC895),
    negative: Color(0xFFF29A8A),
    water: Color(0xFF93C1EE),
    amber: Color(0xFFF2C27E),
    heat: Color(0xFFE6B95C),
    notificationBadge: Color(0xFFF08A5D),
    warningTone: Tone(Color(0xFF3A2B14), Color(0xFFF2C27E)),
    warningBorder: Color(0xFF6B4E22),
    waterTone: Tone(Color(0xFF1C2E42), Color(0xFF93C1EE)),
    waterStrongTone: Tone(Color(0xFF24405E), Color(0xFFB7D6F5)),
    heatTone: Tone(Color(0xFF3A2B14), Color(0xFFF2C27E)),
    normalTone: Tone(Color(0xFF1E3326), Color(0xFF7CC895)),
    soilTone: Tone(Color(0xFF342A1C), Color(0xFFE1C79C)),
    amberTone: Tone(Color(0xFF3A2B14), Color(0xFFF2C27E)),
    neutralTone: Tone(Color(0xFF212B24), Color(0xFF9EABA2)),
    adviceTone: Tone(Color(0xFF1E3326), Color(0xFF7CC895)),
    soilGoodTone: Tone(Color(0xFF1E3326), Color(0xFF7CC895)),
    soilRegularTone: Tone(Color(0xFF3A2B14), Color(0xFFF2C27E)),
    soilTiredTone: Tone(Color(0xFF3D2216), Color(0xFFF4A57E)),
    soilVeryTiredTone: Tone(Color(0xFF45201A), Color(0xFFF29A8A)),
    soilGaugeLow: Color(0xFFF08A5D),
    soilGaugeMid: Color(0xFFE6B95C),
    soilGaugeHigh: Color(0xFF5FBF85),
    mapField: Color(0xFF2A3A2C),
    mapRoad: Color(0xFF3A4A3A),
    mapCanal: Color(0xFF3E5E80),
    mapPlot: Color(0xFF33463A),
    waveformPending: Color(0xFF4F5E54),
    cropPalette: _cropPalette,
    scenarioNormal: Color(0xFF8BB37C),
    semiGuideBackground: Color(0xFF18241C),
    semiGuideBorder: Color(0xFF2F4A37),
    semiHalo: Color(0xFF24402C),
  );

  @override
  AppPalette copyWith() => this;

  // Sin transición gradual entre claro y oscuro: el cambio es inmediato.
  @override
  AppPalette lerp(AppPalette? other, double t) =>
      other == null || t < 0.5 ? this : other;
}

/// Acceso a la paleta del tema: `context.colors.primary`.
extension AppPaletteContext on BuildContext {
  /// Paleta vigente (clara si el tema no la trae, p. ej. en pruebas
  /// aisladas de un widget).
  AppPalette get colors =>
      Theme.of(this).extension<AppPalette>() ?? AppPalette.light;
}
