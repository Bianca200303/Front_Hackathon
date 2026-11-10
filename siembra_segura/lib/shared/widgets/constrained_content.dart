import 'package:flutter/widgets.dart';
import 'package:siembra_segura/core/theme/app_spacing.dart';

/// Limita el ancho del contenido y lo centra en pantallas anchas (tablets),
/// sin imponer tamaños fijos en teléfonos.
class ConstrainedContent extends StatelessWidget {
  const ConstrainedContent({
    required this.child,
    this.maxWidth = AppSizes.maxContentWidth,
    super.key,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
