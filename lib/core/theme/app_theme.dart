import 'package:flutter/material.dart';
import 'package:siembra_segura/core/theme/app_palette.dart';
import 'package:siembra_segura/core/theme/app_spacing.dart';
import 'package:siembra_segura/core/theme/app_typography.dart';

/// Tema de Material construido con los tokens de la app.
abstract final class AppTheme {
  /// Tema claro (el de la referencia).
  static ThemeData light() => _build(AppPalette.light);

  /// Tema oscuro (el de `semi_app.html`).
  static ThemeData dark() => _build(AppPalette.dark);

  static ThemeData _build(AppPalette c) {
    final colorScheme = ColorScheme(
      brightness: c.brightness,
      primary: c.primary,
      onPrimary: c.onPrimary,
      primaryContainer: c.primarySoft,
      onPrimaryContainer: c.primaryDark,
      secondary: c.water,
      onSecondary: c.onPrimary,
      error: c.negative,
      onError: c.onPrimary,
      surface: c.surface,
      onSurface: c.textPrimary,
      onSurfaceVariant: c.textMuted,
      surfaceContainerHighest: c.surfaceMuted,
      outline: c.borderStrong,
      outlineVariant: c.border,
      inverseSurface: c.textPrimary,
      onInverseSurface: c.background,
    );
    final text = AppTextStyles(c);

    const buttonShape = RoundedRectangleBorder(borderRadius: AppRadii.button);
    const buttonMinSize = Size(double.infinity, AppSizes.primaryButtonHeight);
    OutlineInputBorder inputBorder(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(24)),
          borderSide: BorderSide(color: color, width: width),
        );

    final base = ThemeData(
      useMaterial3: true,
      brightness: c.brightness,
      colorScheme: colorScheme,
      fontFamily: AppTypography.fontFamily,
      textTheme: text.textTheme,
      scaffoldBackgroundColor: c.background,
      canvasColor: c.background,
      focusColor: c.focus.withValues(alpha: 0.4),
      materialTapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: VisualDensity.standard,
      extensions: [c],
    );

    return base.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: c.background,
        foregroundColor: c.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: c.primary,
          foregroundColor: c.onPrimary,
          minimumSize: buttonMinSize,
          shape: buttonShape,
          textStyle: AppTypography.primaryButton,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: c.surface,
          foregroundColor: c.primary,
          minimumSize: buttonMinSize,
          shape: buttonShape,
          side: BorderSide(color: c.primary, width: 2),
          textStyle: const TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: c.primary,
          minimumSize: const Size(
            AppSizes.minTouchTarget,
            AppSizes.minTouchTarget,
          ),
          textStyle: AppTypography.textTheme.labelLarge?.copyWith(
            fontFamily: AppTypography.fontFamily,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: c.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.card,
          side: BorderSide(color: c.border),
        ),
      ),
      dividerTheme: DividerThemeData(color: c.border, thickness: 1, space: 1),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.surface,
        modalBackgroundColor: c.surface,
        dragHandleColor: c.borderStrong,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: c.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: Colors.transparent,
        elevation: 0,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: states.contains(WidgetState.selected)
                ? c.primary
                : c.textMuted,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            size: 24,
            color: states.contains(WidgetState.selected)
                ? c.primary
                : c.textMuted,
          ),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: c.surface,
        indicatorColor: Colors.transparent,
        selectedIconTheme: IconThemeData(color: c.primary),
        unselectedIconTheme: IconThemeData(color: c.textMuted),
        selectedLabelTextStyle: TextStyle(
          fontWeight: FontWeight.w700,
          color: c.primary,
        ),
        unselectedLabelTextStyle: TextStyle(
          fontWeight: FontWeight.w700,
          color: c.textMuted,
        ),
      ),
      badgeTheme: BadgeThemeData(backgroundColor: c.notificationBadge),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        hintStyle: text.muted,
        border: inputBorder(c.borderStrong),
        enabledBorder: inputBorder(c.borderStrong),
        focusedBorder: inputBorder(c.focus, 3),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: c.textPrimary,
        contentTextStyle: TextStyle(
          fontFamily: AppTypography.fontFamily,
          color: c.background,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: c.primary),
    );
  }
}
