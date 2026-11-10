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
  static const fontFamily = 'Figtree';

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

  /// Texto secundario (`.suave` en la referencia).
  static const TextStyle muted = TextStyle(
    fontSize: 14,
    height: 1.35,
    color: AppColors.textMuted,
  );

  /// Texto del botón principal (18/700).
  static const TextStyle primaryButton = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );
}
