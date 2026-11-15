import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/services/speech/speech_service.dart';
import 'package:siembra_segura/core/theme/app_palette.dart';
import 'package:siembra_segura/core/theme/app_spacing.dart';
import 'package:siembra_segura/shared/domain/app_mode.dart';
import 'package:siembra_segura/shared/state/app_mode_provider.dart';
import 'package:siembra_segura/shared/widgets/listen_button.dart';
import 'package:siembra_segura/shared/widgets/semi/semi_avatar.dart';
import 'package:siembra_segura/shared/widgets/semi/semi_painter.dart';

/// Semi en lo alto de cada pestaña (`.semi-dice` de `semi_app.html`).
///
/// En [AppMode.assisted] habla con un globo y "Escuchar". En
/// [AppMode.manual] solo aparece "Pregúntale a Semi" (`.ayuda-btn`): al
/// tocarlo se abre el globo y lo lee en voz alta. El modo se cambia en
/// Ajustes o con la Ayuda de Semi.
class SemiGuide extends ConsumerStatefulWidget {
  /// Crea la guía con lo que Semi dice en esta pantalla.
  const SemiGuide({
    required this.message,
    this.expression = SemiExpression.happy,
    super.key,
  });

  /// Lo que dice Semi (también lo lee en voz alta).
  final String message;

  /// Cómo se ve Semi mientras lo dice.
  final SemiExpression expression;

  @override
  ConsumerState<SemiGuide> createState() => _SemiGuideState();
}

class _SemiGuideState extends ConsumerState<SemiGuide> {
  bool _openedInManual = false;

  @override
  Widget build(BuildContext context) {
    final manual = ref.watch(appModeProvider) == AppMode.manual;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenGutter,
        0,
        AppSpacing.screenGutter,
        AppSpacing.md,
      ),
      child: manual && !_openedInManual
          ? Align(
              alignment: AlignmentDirectional.centerStart,
              child: _AskSemiButton(
                onTap: () {
                  setState(() => _openedInManual = true);
                  unawaited(_speak());
                },
              ),
            )
          : SemiGuideCard(
              message: widget.message,
              expression: widget.expression,
            ),
    );
  }

  Future<void> _speak() async {
    try {
      await ref.read(speechServiceProvider).speak(widget.message);
    } on SpeechUnavailableException {
      // Sin voz igual queda el globo con el texto.
    }
  }
}

/// "Pregúntale a Semi" del modo manual.
class _AskSemiButton extends StatelessWidget {
  const _AskSemiButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: BorderSide(color: colors.semiGuideBorder),
    );
    return Material(
      color: colors.surface,
      shape: shape,
      child: InkWell(
        customBorder: shape,
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AppSizes.minTouchTarget),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 14, 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: AppSpacing.sm,
              children: [
                const SemiAvatar(expression: SemiExpression.happy, size: 30),
                Flexible(
                  child: Text(
                    AppLocalizations.of(context).helpTitle,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: colors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Semi con su globo de diálogo y "Escuchar" (`.semi-dice`).
class SemiGuideCard extends StatelessWidget {
  /// Crea la tarjeta.
  const SemiGuideCard({
    required this.message,
    this.expression = SemiExpression.happy,
    super.key,
  });

  /// Lo que dice Semi.
  final String message;

  /// Expresión de Semi.
  final SemiExpression expression;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.sm,
      children: [
        SemiAvatar(
          expression: expression,
          size: 56,
          semanticLabel: AppLocalizations.of(context).semiAvatarSemantics,
        ),
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.surface,
              border: Border.all(color: colors.semiGuideBorder),
              // La esquina recta "sale" de Semi.
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(14),
                bottomLeft: Radius.circular(14),
                bottomRight: Radius.circular(14),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.sm,
                children: [
                  Semantics(
                    liveRegion: true,
                    child: Text(
                      message,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.45,
                        color: colors.textBody,
                      ),
                    ),
                  ),
                  ListenButton(text: message),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
