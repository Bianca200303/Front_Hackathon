import 'package:flutter/material.dart';
import 'package:siembra_segura/core/theme/app_colors.dart';
import 'package:siembra_segura/core/theme/app_spacing.dart';
import 'package:siembra_segura/core/theme/app_typography.dart';

/// Variantes de botón de la referencia: `.btn`, `.btn2` y `.btn3`.
enum AppButtonVariant {
  /// Relleno verde. Acción principal.
  primary,

  /// Fondo blanco y borde gris. Acción secundaria.
  secondary,

  /// Borde verde de 2 px. Acción alternativa destacada.
  outline,
}

/// Botón de acción de la app (`.btn` en la referencia).
class AppButton extends StatelessWidget {
  /// Crea el botón; con [onPressed] nulo queda deshabilitado.
  const AppButton({
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.compact = false,
    super.key,
  });

  /// Texto del botón.
  final String label;

  /// Acción al tocar; `null` lo deshabilita.
  final VoidCallback? onPressed;

  /// Estilo visual.
  final AppButtonVariant variant;

  /// Altura de 48 dp y texto de 15 (`.btn.chico`).
  final bool compact;

  static const _compactSize = Size(
    double.infinity,
    AppSizes.compactButtonHeight,
  );
  static const _compactText = AppTypography.compactButton;

  @override
  Widget build(BuildContext context) {
    final child = Text(label, textAlign: TextAlign.center);
    return switch (variant) {
      AppButtonVariant.primary => FilledButton(
        onPressed: onPressed,
        style: compact
            ? FilledButton.styleFrom(
                minimumSize: _compactSize,
                textStyle: _compactText,
              )
            : null,
        child: child,
      ),
      AppButtonVariant.secondary => OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          minimumSize: _compactSize,
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.borderStrong),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppRadii.md)),
          ),
          textStyle: _compactText,
        ),
        child: child,
      ),
      AppButtonVariant.outline => OutlinedButton(
        onPressed: onPressed,
        style: compact
            ? OutlinedButton.styleFrom(
                minimumSize: _compactSize,
                textStyle: _compactText,
              )
            : null,
        child: child,
      ),
    };
  }
}
