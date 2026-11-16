import 'package:flutter/material.dart';
import 'package:siembra_segura/core/theme/app_palette.dart';
import 'package:siembra_segura/core/theme/app_spacing.dart';
import 'package:siembra_segura/core/theme/app_typography.dart';

/// Aviso amable (no un error): una regla que rompe la secuencia o poca agua
/// para un cultivo que pide mucha.
class WarningNote extends StatelessWidget {
  /// Crea el aviso con [text].
  const WarningNote(this.text, {super.key});

  /// Lo que se avisa, en palabras del agricultor.
  final String text;

  @override
  Widget build(BuildContext context) {
    final tone = context.colors.warningTone;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: tone.background,
        borderRadius: const BorderRadius.all(Radius.circular(AppRadii.sm)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.sm,
          children: [
            Icon(Icons.info_outline_rounded, size: 20, color: tone.foreground),
            Expanded(
              child: Text(
                text,
                style: context.text.bodyCompact.copyWith(
                  color: tone.foreground,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
