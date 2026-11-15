import 'package:flutter/material.dart';
import 'package:siembra_segura/core/theme/app_palette.dart';
import 'package:siembra_segura/core/theme/app_spacing.dart';

/// Variantes de `.tarjeta` en la referencia.
enum AppCardVariant {
  /// Tarjeta blanca con borde suave.
  standard,

  /// Borde verde de 2 px: la opción recomendada.
  highlighted,

  /// Menos relleno y separación.
  compact,

  /// Sin relleno: contenido a sangre (mapas, imágenes).
  flush,
}

/// Tarjeta blanca con borde (`.tarjeta`) que apila sus hijos.
class AppCard extends StatelessWidget {
  /// Crea la tarjeta.
  const AppCard({
    required this.children,
    this.variant = AppCardVariant.standard,
    super.key,
  });

  /// Contenido, separado verticalmente.
  final List<Widget> children;

  /// Estilo de la tarjeta.
  final AppCardVariant variant;

  @override
  Widget build(BuildContext context) {
    final (padding, gap) = switch (variant) {
      AppCardVariant.standard ||
      AppCardVariant.highlighted => (const EdgeInsets.all(AppSpacing.lg), 10.0),
      AppCardVariant.compact => (
        const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        AppSpacing.xs,
      ),
      AppCardVariant.flush => (EdgeInsets.zero, 0.0),
    };

    return Container(
      clipBehavior: variant == AppCardVariant.flush
          ? Clip.antiAlias
          : Clip.none,
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: AppRadii.card,
        border: variant == AppCardVariant.highlighted
            ? Border.all(color: context.colors.primary, width: 2)
            : Border.all(color: context.colors.border),
      ),
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        spacing: gap,
        children: children,
      ),
    );
  }
}
