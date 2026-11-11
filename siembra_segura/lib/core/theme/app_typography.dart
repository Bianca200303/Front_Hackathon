import 'package:flutter/material.dart';
import 'package:siembra_segura/core/theme/app_colors.dart';

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
      color: AppColors.textPrimary,
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      height: 1.15,
      fontWeight: FontWeight.w800,
      color: AppColors.textPrimary,
    ),
    titleLarge: TextStyle(
      fontSize: 22,
      height: 1.2,
      fontWeight: FontWeight.w800,
      color: AppColors.textPrimary,
    ),
    titleMedium: TextStyle(
      fontSize: 17,
      height: 1.25,
      fontWeight: FontWeight.w800,
      color: AppColors.textPrimary,
    ),
    titleSmall: TextStyle(
      fontSize: 15,
      height: 1.3,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      height: 1.45,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
    ),
    bodyMedium: TextStyle(
      fontSize: 15,
      height: 1.4,
      fontWeight: FontWeight.w400,
      color: AppColors.textBody,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      height: 1.35,
      fontWeight: FontWeight.w400,
      color: AppColors.textMuted,
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
      color: AppColors.textMuted,
    ),
    labelSmall: TextStyle(
      fontSize: 12,
      height: 1.2,
      fontWeight: FontWeight.w600,
      color: AppColors.textMuted,
    ),
  );

  // Estilos con nombre que no tienen equivalente en el TextTheme. Los
  // widgets usan el TextTheme o estos tokens; nunca un `fontSize` suelto.
  // Para variar solo el color se usa `copyWith(color: ...)`.

  /// Texto secundario (`.suave` en la referencia), 14.
  static const TextStyle muted = TextStyle(
    fontSize: 14,
    height: 1.35,
    color: AppColors.textMuted,
  );

  /// Parte destacada dentro de un texto [muted] (p. ej., el cultivo que
  /// detectó el satélite). Se combina sobre el estilo base.
  static const TextStyle mutedEmphasis = TextStyle(
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  /// Etiqueta secundaria semibold, como "(opcional)".
  static final TextStyle mutedLabel = muted.copyWith(
    fontWeight: FontWeight.w600,
  );

  /// Texto de lectura compacto dentro de tarjetas (definiciones, fichas),
  /// 14 con interlineado amplio.
  static const TextStyle bodyCompact = TextStyle(
    fontSize: 14,
    height: 1.45,
    color: AppColors.textBody,
  );

  /// Etiqueta de fila semibold (p. ej., nombre del escenario), 14/600.
  static const TextStyle rowLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  /// Nota pequeña (fuentes de datos, subtítulos), 13.
  static const TextStyle caption = TextStyle(
    fontSize: 13,
    height: 1.4,
    color: AppColors.textMuted,
  );

  /// Nota pequeña destacada (día de la semana), 13/700.
  static const TextStyle captionStrong = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  /// Nota pequeña semibold atenuada (periodos del plan), 13/600.
  static const TextStyle captionMuted = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textMuted,
  );

  /// Título de tarjeta de opción y marca de la app, 19/800.
  static const TextStyle cardTitle = TextStyle(
    fontSize: 19,
    height: 1.2,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  /// Título de aviso o tarjeta destacada pequeña, 16/800.
  static const TextStyle emphasis = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  /// Texto de una opción tipo radio, 16/700.
  static const TextStyle option = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
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
    color: AppColors.textPrimary,
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
  static const TextStyle compactButton = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
  );

  /// Texto del botón principal, 18/700.
  static const TextStyle primaryButton = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );
}
