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
    // Estilo de `semi_app.html` (v4): secciones planas separadas por una
    // línea; la destacada, con franja verde a la izquierda.
    final colors = context.colors;
    final (padding, gap) = switch (variant) {
      AppCardVariant.standard => (
        const EdgeInsets.only(top: AppSpacing.lg, bottom: 2),
        10.0,
      ),
      AppCardVariant.highlighted => (
        const EdgeInsets.fromLTRB(16, 14, 16, 14),
        10.0,
      ),
      AppCardVariant.compact => (
        const EdgeInsets.symmetric(vertical: AppSpacing.md),
        AppSpacing.xs,
      ),
      AppCardVariant.flush => (EdgeInsets.zero, 0.0),
    };
    final decoration = switch (variant) {
      AppCardVariant.highlighted => BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(8)),
        border: Border(left: BorderSide(color: colors.primary, width: 6)),
      ),
      AppCardVariant.flush => BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colors.border),
      ),
      _ => BoxDecoration(
        border: Border(top: BorderSide(color: colors.borderStrong)),
      ),
    };

    return Container(
      clipBehavior: variant == AppCardVariant.flush
          ? Clip.antiAlias
          : Clip.none,
      decoration: decoration,
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
