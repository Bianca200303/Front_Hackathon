import 'package:flutter/material.dart';
import 'package:siembra_segura/core/theme/app_colors.dart';
import 'package:siembra_segura/core/theme/app_spacing.dart';
import 'package:siembra_segura/core/theme/app_typography.dart';

/// Etiqueta con forma de píldora (`.estado`, `.tierra`, `.etiqueta`).
class StatusPill extends StatelessWidget {
  /// Crea la píldora.
  const StatusPill({
    required this.label,
    required this.tone,
    this.dense = false,
    super.key,
  });

  /// Texto de la píldora.
  final String label;

  /// Colores de fondo y texto.
  final Tone tone;

  /// Texto de 12 en lugar de 13 (`.etiqueta`).
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: tone.background,
        borderRadius: const BorderRadius.all(Radius.circular(AppRadii.pill)),
      ),
      child: Text(
        label,
        style: (dense ? AppTypography.pillDense : AppTypography.pill).copyWith(
          color: tone.foreground,
        ),
      ),
    );
  }
}

/// Bloque de color con el nombre de un cultivo (`.bloque`, `.cultivo`).
class ColoredBlock extends StatelessWidget {
  /// Crea el bloque.
  const ColoredBlock({
    required this.label,
    required this.tone,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    this.compact = false,
    super.key,
  });

  /// Nombre a mostrar.
  final String label;

  /// Colores de fondo y texto.
  final Tone tone;

  /// Relleno interior.
  final EdgeInsets padding;

  /// Texto un punto más pequeño, para bloques estrechos (calendario).
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: tone.background,
        borderRadius: const BorderRadius.all(Radius.circular(AppRadii.sm)),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.fade,
        softWrap: false,
        style:
            (compact
                    ? AppTypography.blockLabelCompact
                    : AppTypography.blockLabel)
                .copyWith(color: tone.foreground),
      ),
    );
  }
}
