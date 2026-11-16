import 'package:flutter/material.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/theme/app_palette.dart';
import 'package:siembra_segura/core/theme/app_spacing.dart';

/// Franja fija "Datos de ejemplo" sobre toda la app con `DATA_SOURCE=mock`.
///
/// Las cifras de ejemplo no salen de ninguna medición: el rótulo evita que
/// se lean como datos de la NASA (en un video o una demo).
class SampleDataBanner extends StatelessWidget {
  /// Envuelve [child] con la franja arriba.
  const SampleDataBanner({required this.child, super.key});

  /// La app.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tone = context.colors.amberTone;
    final text = AppLocalizations.of(context).sampleDataBanner;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ColoredBox(
          color: tone.background,
          child: SafeArea(
            bottom: false,
            child: Semantics(
              container: true,
              label: text,
              excludeSemantics: true,
              child: MediaQuery.withClampedTextScaling(
                maxScaleFactor: 1.3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: tone.foreground,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: child,
          ),
        ),
      ],
    );
  }
}
