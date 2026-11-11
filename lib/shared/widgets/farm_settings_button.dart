import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/router/app_routes.dart';
import 'package:siembra_segura/core/theme/app_colors.dart';

/// Abre "Mi parcela" encima de la pantalla actual para cambiar el último
/// cultivo, la prioridad o las restricciones.
///
/// Usa `push` para que "Volver" regrese exactamente a donde estaba el
/// agricultor. Navega por ruta, así que cualquier feature puede usarlo sin
/// depender del feature `farm`.
class FarmSettingsButton extends StatelessWidget {
  /// Crea el botón.
  const FarmSettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: AppLocalizations.of(context).farmSettingsTooltip,
      color: AppColors.primary,
      icon: const Icon(Icons.tune_rounded),
      onPressed: () => context.push(AppRoutes.farm),
    );
  }
}
