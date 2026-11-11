import 'package:flutter/widgets.dart';
import 'package:siembra_segura/core/theme/app_breakpoints.dart';
import 'package:siembra_segura/core/theme/app_spacing.dart';

/// Coloca [children] en una columna en teléfonos y en filas de dos columnas
/// cuando hay ancho suficiente (tablets, ventanas anchas).
///
/// Decide según el ancho disponible para el contenido, no según el ancho
/// de la pantalla, así que funciona igual dentro de un riel lateral o de un
/// contenedor centrado.
class ResponsiveColumns extends StatelessWidget {
  /// Crea el grupo adaptable.
  const ResponsiveColumns({
    required this.children,
    this.spacing = AppSpacing.sectionGap,
    super.key,
  });

  /// Bloques a colocar, en orden de lectura.
  final List<Widget> children;

  /// Separación entre bloques, horizontal y vertical.
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < AppBreakpoints.twoColumnContent) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: spacing,
            children: children,
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: spacing,
          children: [
            for (var i = 0; i < children.length; i += 2)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: spacing,
                children: [
                  Expanded(child: children[i]),
                  // Fila impar: hueco vacío para mantener el ancho.
                  Expanded(
                    child: i + 1 < children.length
                        ? children[i + 1]
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
          ],
        );
      },
    );
  }
}
