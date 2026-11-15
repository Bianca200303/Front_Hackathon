import 'package:flutter/material.dart';
import 'package:siembra_segura/core/theme/app_palette.dart';
import 'package:siembra_segura/core/theme/app_spacing.dart';

/// Bloque desplegable de explicación (`<details class="significa">`).
///
/// Usa [ExpansionTile] para heredar su accesibilidad (estado
/// expandido/contraído anunciado por los lectores de pantalla).
class ExplainerTile extends StatelessWidget {
  /// Crea el desplegable.
  const ExplainerTile({
    required this.title,
    required this.children,
    this.framed = true,
    super.key,
  });

  /// Texto del encabezado (p. ej., "¿Qué significa?").
  final String title;

  /// Contenido que aparece al desplegar.
  final List<Widget> children;

  /// Con fondo blanco y borde propio. Dentro de una tarjeta, `false`.
  final bool framed;

  @override
  Widget build(BuildContext context) {
    final tile = Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(color: context.colors.primary),
        ),
        tilePadding: EdgeInsets.zero,
        minTileHeight: AppSizes.minTouchTarget,
        shape: const Border(),
        collapsedShape: const Border(),
        iconColor: context.colors.primary,
        collapsedIconColor: context.colors.primary,
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        expandedAlignment: Alignment.centerLeft,
        childrenPadding: const EdgeInsets.only(bottom: AppSpacing.sm),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 6,
            children: children,
          ),
        ],
      ),
    );

    if (!framed) return tile;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border.all(color: context.colors.border),
        borderRadius: const BorderRadius.all(Radius.circular(AppRadii.md)),
      ),
      child: tile,
    );
  }
}
