import 'package:flutter/material.dart';
import 'package:siembra_segura/core/theme/app_palette.dart';
import 'package:siembra_segura/core/theme/app_spacing.dart';
import 'package:siembra_segura/core/theme/app_typography.dart';

/// Tarjeta tocable con icono, título y descripción (`.aviso-item`).
class NoticeTile extends StatelessWidget {
  /// Crea el aviso.
  const NoticeTile({
    required this.icon,
    required this.iconTone,
    required this.title,
    required this.body,
    required this.onTap,
    this.meta,
    super.key,
  });

  /// Icono a la izquierda.
  final IconData icon;

  /// Colores del círculo del icono.
  final Tone iconTone;

  /// Título en negrita.
  final String title;

  /// Texto descriptivo.
  final String body;

  /// Dato secundario (p. ej., "hace 2 horas").
  final String? meta;

  /// Acción al tocar el aviso.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // `.aviso` de `semi_app.html`: fila plana separada por una línea, con
    // el icono en un cuadrado de color.
    final metaText = meta;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: context.colors.borderStrong)),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.md,
            children: [
              ExcludeSemantics(
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconTone.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 22, color: iconTone.foreground),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.xxs,
                  children: [
                    Text(title, style: context.text.emphasis),
                    Text(
                      body,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: context.colors.textPrimary,
                      ),
                    ),
                    if (metaText != null)
                      Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.xxs),
                        child: Text(
                          metaText,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
