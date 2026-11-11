import 'package:flutter/material.dart';
import 'package:siembra_segura/core/theme/app_colors.dart';
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
    const shape = RoundedRectangleBorder(
      borderRadius: AppRadii.card,
      side: BorderSide(color: AppColors.border),
    );
    final metaText = meta;
    return Material(
      color: AppColors.surface,
      shape: shape,
      child: InkWell(
        customBorder: shape,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 22, color: iconTone.foreground),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.xxs,
                  children: [
                    Text(title, style: AppTypography.emphasis),
                    Text(
                      body,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
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
