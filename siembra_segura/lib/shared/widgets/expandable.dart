import 'package:flutter/material.dart';
import 'package:siembra_segura/core/theme/app_palette.dart';
import 'package:siembra_segura/core/theme/app_spacing.dart';

/// Texto que se despliega al tocar el título (`details.significa`).
class Expandable extends StatefulWidget {
  /// Crea el desplegable.
  const Expandable({
    required this.title,
    required this.child,
    this.initiallyOpen = false,
    super.key,
  });

  /// Si empieza abierto.
  final bool initiallyOpen;

  /// Título (verde, tocable).
  final String title;

  /// Lo que se muestra al abrir.
  final Widget child;

  @override
  State<Expandable> createState() => _ExpandableState();
}

class _ExpandableState extends State<Expandable> {
  late bool _open = widget.initiallyOpen;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          button: true,
          expanded: _open,
          child: InkWell(
            onTap: () => setState(() => _open = !_open),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: AppSizes.minTouchTarget,
              ),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: colors.primary,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (_open) widget.child,
      ],
    );
  }
}
