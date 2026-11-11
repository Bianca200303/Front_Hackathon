import 'package:flutter/widgets.dart';
import 'package:siembra_segura/core/theme/app_spacing.dart';

/// Limita el ancho del contenido y lo centra en pantallas anchas (tablets),
/// sin imponer tamaños fijos en teléfonos.
class ConstrainedContent extends StatelessWidget {
  /// Crea el contenedor.
  const ConstrainedContent({
    required this.child,
    this.maxWidth = AppSizes.maxContentWidth,
    super.key,
  });

  /// Contenido a limitar.
  final Widget child;

  /// Ancho máximo, en dp.
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    // heightFactor: 1 → toma la altura de su contenido. Sin él, Align ocupa
    // todo el alto disponible, lo que rompe su uso en pies de pantalla.
    return Align(
      alignment: Alignment.topCenter,
      heightFactor: 1,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
