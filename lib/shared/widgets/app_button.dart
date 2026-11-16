import 'package:flutter/material.dart';
import 'package:siembra_segura/core/theme/app_palette.dart';
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
    this.icon,
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

  /// Icono opcional antes del texto, cuando ayuda a entender la acción
  /// (p. ej., un calendario para abrir el selector de fechas).
  final IconData? icon;

  static const _compactSize = Size(
    double.infinity,
    AppSizes.compactButtonHeight,
  );
  static const _compactText = AppTypography.compactButton;

  @override
  Widget build(BuildContext context) {
    final text = Text(label, textAlign: TextAlign.center);
    final child = icon == null
        ? text
        : Row(
            mainAxisSize: MainAxisSize.min,
            spacing: AppSpacing.sm,
            children: [
              ExcludeSemantics(child: Icon(icon)),
              Flexible(child: text),
            ],
          );
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
          foregroundColor: context.colors.textPrimary,
          side: BorderSide(color: context.colors.borderStrong),
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
