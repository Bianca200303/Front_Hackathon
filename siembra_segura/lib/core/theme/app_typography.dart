import 'package:flutter/material.dart';
import 'package:siembra_segura/core/theme/app_palette.dart';

/// Tipografía de la referencia (Figtree), mapeada al `TextTheme` de Material
/// para que los widgets usen `Theme.of(context).textTheme`.
///
/// | Referencia CSS | TextTheme        |
/// |----------------|------------------|
/// | h1 26/800      | headlineMedium   |
/// | .grande 24/800 | headlineSmall    |
/// | 22/800 (cifras)| titleLarge       |
/// | h2 17/800      | titleMedium      |
/// | .pregunta 15/700 | titleSmall     |
/// | 16 (burbujas)  | bodyLarge        |
/// | .texto 15      | bodyMedium       |
/// | .nota 12       | bodySmall        |
/// | botón 15/700   | labelLarge       |
/// | .sobre 13/800  | labelMedium      |
/// | .paso 12/600   | labelSmall       |
abstract final class AppTypography {
  /// Fuente de la app, incluida en `assets/fonts` (licencia OFL).
  static const fontFamily = 'Figtree';

  /// Escala tipográfica de Material (ver tabla arriba).
  static const TextTheme textTheme = TextTheme(
    headlineMedium: TextStyle(
      fontSize: 26,
      height: 1.15,
      fontWeight: FontWeight.w800,
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      height: 1.15,
      fontWeight: FontWeight.w800,
    ),
    titleLarge: TextStyle(
      fontSize: 22,
      height: 1.2,
      fontWeight: FontWeight.w800,
    ),
    titleMedium: TextStyle(
      fontSize: 17,
      height: 1.25,
      fontWeight: FontWeight.w800,
    ),
    titleSmall: TextStyle(
      fontSize: 15,
      height: 1.3,
      fontWeight: FontWeight.w700,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      height: 1.45,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: TextStyle(
      fontSize: 15,
      height: 1.4,
      fontWeight: FontWeight.w400,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      height: 1.35,
      fontWeight: FontWeight.w400,
    ),
    labelLarge: TextStyle(
      fontSize: 15,
      height: 1.2,
      fontWeight: FontWeight.w700,
    ),
    labelMedium: TextStyle(
      fontSize: 13,
      height: 1.2,
      fontWeight: FontWeight.w800,
      letterSpacing: 0.4,
    ),
    labelSmall: TextStyle(
      fontSize: 12,
      height: 1.2,
      fontWeight: FontWeight.w600,
    ),
  );

  // Estilos con nombre que no tienen equivalente en el TextTheme. Los
  // widgets usan el TextTheme o estos tokens; nunca un `fontSize` suelto.
  // No llevan color: el color sale del tema (`context.text`, abajo).

  /// Texto secundario (`.suave` en la referencia), 14.
  static const TextStyle muted = TextStyle(fontSize: 14, height: 1.35);

  /// Parte destacada dentro de un texto [muted] (p. ej., el cultivo que
  /// detectó el satélite). Se combina sobre el estilo base.
  static const TextStyle mutedEmphasis = TextStyle(fontWeight: FontWeight.w700);

  /// Etiqueta secundaria semibold, como "(opcional)".
  static final TextStyle mutedLabel = muted.copyWith(
    fontWeight: FontWeight.w600,
  );

  /// Texto de lectura compacto dentro de tarjetas (definiciones, fichas),
  /// 14 con interlineado amplio.
  static const TextStyle bodyCompact = TextStyle(fontSize: 14, height: 1.45);

  /// Etiqueta de fila semibold (p. ej., nombre del escenario), 14/600.
  static const TextStyle rowLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  /// Nota pequeña (fuentes de datos, subtítulos), 13.
  static const TextStyle caption = TextStyle(fontSize: 13, height: 1.4);

  /// Nota pequeña destacada (día de la semana), 13/700.
  static const TextStyle captionStrong = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
  );

  /// Nota pequeña semibold atenuada (periodos del plan), 13/600.
  static const TextStyle captionMuted = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );

  /// Título de tarjeta de opción y marca de la app, 19/800.
  static const TextStyle cardTitle = TextStyle(
    fontSize: 19,
    height: 1.2,
    fontWeight: FontWeight.w800,
  );

  /// Título de aviso o tarjeta destacada pequeña, 16/800.
  static const TextStyle emphasis = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w800,
  );

  /// Texto de una opción tipo radio, 16/700.
  static const TextStyle option = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  /// Texto de chip seleccionable, 15/600.
  static const TextStyle chip = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );

  /// Cifra de una métrica (S/, m³), 15/800.
  static const TextStyle metricValue = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w800,
  );

  /// Texto de píldora de estado, 13/800.
  static const TextStyle pill = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w800,
  );

  /// Texto de píldora compacta, 12/800.
  static const TextStyle pillDense = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w800,
  );

  /// Nombre de cultivo dentro de un bloque de color, 15/800.
  static const TextStyle blockLabel = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w800,
  );

  /// Variante compacta de [blockLabel], 14/800.
  static const TextStyle blockLabelCompact = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w800,
  );

  /// Texto de botón compacto y botón "Escuchar", 15/700.
  // Los botones no heredan la fuente del tema: hay que nombrarla.
  static const TextStyle compactButton = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w700,
  );

  /// Texto del botón principal, 18/700.
  ///
  /// Lleva [fontFamily]: los botones no heredan la fuente del tema.
  static const TextStyle primaryButton = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );
}

/// Los estilos de [AppTypography] con el color de la paleta vigente.
///
/// Se usan con `context.text.muted`, igual que `Theme.of(context).textTheme`
/// para la escala de Material.
class AppTextStyles {
  /// Crea los estilos para [palette].
  const AppTextStyles(this.palette);

  /// Paleta de la que salen los colores.
  final AppPalette palette;

  /// Escala de Material con sus colores (la usa `AppTheme`).
  TextTheme get textTheme {
    const t = AppTypography.textTheme;
    TextStyle? paint(TextStyle? style, Color color) =>
        style?.copyWith(color: color);
    return t.copyWith(
      headlineMedium: paint(t.headlineMedium, palette.textPrimary),
      headlineSmall: paint(t.headlineSmall, palette.textPrimary),
      titleLarge: paint(t.titleLarge, palette.textPrimary),
      titleMedium: paint(t.titleMedium, palette.textPrimary),
      titleSmall: paint(t.titleSmall, palette.textPrimary),
      bodyLarge: paint(t.bodyLarge, palette.textPrimary),
      bodyMedium: paint(t.bodyMedium, palette.textBody),
      bodySmall: paint(t.bodySmall, palette.textMuted),
      labelMedium: paint(t.labelMedium, palette.textMuted),
      labelSmall: paint(t.labelSmall, palette.textMuted),
    );
  }

  /// [AppTypography.muted] en texto secundario.
  TextStyle get muted => AppTypography.muted.copyWith(color: palette.textMuted);

  /// [AppTypography.mutedEmphasis] en verde de marca.
  TextStyle get mutedEmphasis =>
      AppTypography.mutedEmphasis.copyWith(color: palette.primary);

  /// [AppTypography.mutedLabel] en texto secundario.
  TextStyle get mutedLabel =>
      AppTypography.mutedLabel.copyWith(color: palette.textMuted);

  /// [AppTypography.bodyCompact] en texto de párrafo.
  TextStyle get bodyCompact =>
      AppTypography.bodyCompact.copyWith(color: palette.textBody);

  /// [AppTypography.rowLabel] en texto principal.
  TextStyle get rowLabel =>
      AppTypography.rowLabel.copyWith(color: palette.textPrimary);

  /// [AppTypography.caption] en texto secundario.
  TextStyle get caption =>
      AppTypography.caption.copyWith(color: palette.textMuted);

  /// [AppTypography.captionStrong] en texto principal.
  TextStyle get captionStrong =>
      AppTypography.captionStrong.copyWith(color: palette.textPrimary);

  /// [AppTypography.captionMuted] en texto secundario.
  TextStyle get captionMuted =>
      AppTypography.captionMuted.copyWith(color: palette.textMuted);

  /// [AppTypography.cardTitle] en texto principal.
  TextStyle get cardTitle =>
      AppTypography.cardTitle.copyWith(color: palette.textPrimary);

  /// [AppTypography.emphasis] en texto principal.
  TextStyle get emphasis =>
      AppTypography.emphasis.copyWith(color: palette.textPrimary);

  /// [AppTypography.option] en texto principal.
  TextStyle get option =>
      AppTypography.option.copyWith(color: palette.textPrimary);

  /// [AppTypography.metricValue] en texto principal.
  TextStyle get metricValue =>
      AppTypography.metricValue.copyWith(color: palette.textPrimary);
}

/// Acceso a los estilos con color: `context.text.muted`.
extension AppTextStylesContext on BuildContext {
  /// Estilos de texto con los colores de la paleta vigente.
  AppTextStyles get text => AppTextStyles(colors);
}
