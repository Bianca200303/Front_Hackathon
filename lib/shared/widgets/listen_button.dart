import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/services/speech/speech_service.dart';
import 'package:siembra_segura/core/theme/app_colors.dart';
import 'package:siembra_segura/core/theme/app_spacing.dart';
import 'package:siembra_segura/core/theme/app_typography.dart';

/// Botón "Escuchar": lee en voz alta el contenido de la pantalla.
///
/// Se deshabilita mientras [text] es nulo (por ejemplo, durante la carga).
class ListenButton extends ConsumerWidget {
  /// Crea el botón; con [text] nulo queda deshabilitado.
  const ListenButton({required this.text, this.compact = false, super.key});

  /// Texto a leer; `null` mientras la pantalla aún carga.
  final String? text;

  /// Solo icono, para cabeceras angostas o con texto muy grande.
  final bool compact;

  Future<void> _speak(BuildContext context, WidgetRef ref, String text) async {
    final messenger = ScaffoldMessenger.maybeOf(context);
    final message = AppLocalizations.of(context).errorSpeechUnavailable;
    try {
      await ref.read(speechServiceProvider).speak(text);
    } on SpeechUnavailableException {
      messenger?.showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final content = text;
    final onPressed = content == null
        ? null
        : () => _speak(context, ref, content);
    const side = BorderSide(color: AppColors.borderStrong);

    if (compact) {
      return IconButton.outlined(
        tooltip: l10n.actionListenSemantics,
        onPressed: onPressed,
        icon: const Icon(Icons.volume_up_rounded),
        style: IconButton.styleFrom(
          minimumSize: const Size.square(AppSizes.minTouchTarget),
          foregroundColor: AppColors.textPrimary,
          side: side,
        ),
      );
    }

    return Tooltip(
      message: l10n.actionListenSemantics,
      excludeFromSemantics: true,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.volume_up_rounded, size: 20),
        label: Text(l10n.actionListen),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, AppSizes.minTouchTarget),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          foregroundColor: AppColors.textPrimary,
          side: side,
          shape: const StadiumBorder(),
          textStyle: AppTypography.compactButton,
        ),
      ),
    );
  }
}
