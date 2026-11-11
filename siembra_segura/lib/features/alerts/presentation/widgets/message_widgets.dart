import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/router/app_routes.dart';
import 'package:siembra_segura/core/services/speech/speech_service.dart';
import 'package:siembra_segura/core/theme/app_colors.dart';
import 'package:siembra_segura/core/theme/app_spacing.dart';
import 'package:siembra_segura/core/theme/app_typography.dart';
import 'package:siembra_segura/features/alerts/presentation/alert_texts.dart';
import 'package:siembra_segura/shared/widgets/screen_layout.dart';

/// Cabecera verde estilo chat (`.chat-cab`).
class ChatHeader extends StatelessWidget {
  /// Crea la cabecera.
  const ChatHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Material(
      color: AppColors.primary,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.sm,
            AppSpacing.sm,
            AppSpacing.screenGutter,
            AppSpacing.sm,
          ),
          child: Row(
            spacing: AppSpacing.md,
            children: [
              const AppBackButton(
                fallbackLocation: AppRoutes.alerts,
                color: AppColors.onPrimary,
              ),
              const AppLogo(
                size: 40,
                background: AppColors.surface,
                foreground: AppColors.primary,
                circular: true,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Semantics(
                      header: true,
                      child: Text(
                        l10n.appTitle,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: AppColors.onPrimary),
                      ),
                    ),
                    Text(
                      l10n.messageChannel,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.onPrimary.withValues(alpha: 0.9),
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

/// Burbuja de mensaje recibido (`.burbuja`).
class MessageBubble extends StatelessWidget {
  /// Crea la burbuja.
  const MessageBubble({
    required this.child,
    this.padding = const EdgeInsets.all(14),
    super.key,
  });

  /// Contenido de la burbuja.
  final Widget child;

  /// Relleno interior.
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 340),
        child: Container(
          padding: padding,
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Texto que interpreta `**énfasis**`.
class EmphasisText extends StatelessWidget {
  /// Crea el texto a partir de [source], con marcas de énfasis.
  const EmphasisText(this.source, {this.style, super.key});

  /// Texto con las partes destacadas entre dobles asteriscos.
  final String source;

  /// Estilo base.
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: style,
        children: [
          for (final segment in parseEmphasis(source))
            TextSpan(
              text: segment.text,
              style: segment.emphasized
                  ? const TextStyle(fontWeight: FontWeight.w700)
                  : null,
            ),
        ],
      ),
    );
  }
}

/// Mensaje de audio: reproduce el texto del aviso con la voz del celular.
class AudioMessageBubble extends ConsumerWidget {
  /// Crea la burbuja de audio.
  const AudioMessageBubble({
    required this.text,
    required this.duration,
    super.key,
  });

  /// Texto que se lee al tocar "reproducir".
  final String text;

  /// Duración que se muestra.
  final Duration duration;

  Future<void> _play(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.maybeOf(context);
    final error = AppLocalizations.of(context).errorSpeechUnavailable;
    try {
      await ref.read(speechServiceProvider).speak(text);
    } on SpeechUnavailableException {
      messenger?.showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MessageBubble(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: AppSpacing.md,
        children: [
          IconButton.filled(
            tooltip: AppLocalizations.of(context).messagePlayAudio,
            onPressed: () => _play(context, ref),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              minimumSize: const Size.square(AppSizes.minTouchTarget),
            ),
            icon: const Icon(Icons.play_arrow_rounded),
          ),
          const Flexible(
            child: ExcludeSemantics(
              child: SizedBox(
                width: 160,
                height: 28,
                child: CustomPaint(painter: _WaveformPainter()),
              ),
            ),
          ),
          Text(formatAudioDuration(duration), style: AppTypography.muted),
        ],
      ),
    );
  }
}

/// Onda decorativa del audio, como en la referencia.
class _WaveformPainter extends CustomPainter {
  const _WaveformPainter();

  static const _barHeights = [
    8, 16, 24, 12, 20, 8, 16, 24, 12, 20, //
    8, 16, 24, 12, 8, 20, 12, 8, 16, 8,
  ];
  static const _playedBars = 8;
  static const _pendingColor = AppColors.waveformPending;

  @override
  void paint(Canvas canvas, Size size) {
    final step = size.width / _barHeights.length;
    final barWidth = step / 2;
    for (final (index, height) in _barHeights.indexed) {
      final barHeight = size.height * height / 28;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            index * step,
            (size.height - barHeight) / 2,
            barWidth,
            barHeight,
          ),
          const Radius.circular(2),
        ),
        Paint()
          ..color = index < _playedBars ? AppColors.primary : _pendingColor,
      );
    }
  }

  @override
  bool shouldRepaint(_WaveformPainter oldDelegate) => false;
}

/// Campo para preguntar. Deshabilitado hasta que exista el asistente
/// (decisión B9).
class ChatInputBar extends StatelessWidget {
  /// Crea la barra.
  const ChatInputBar({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Material(
      color: AppColors.chatBackground,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          child: Row(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: l10n.messageInputLabel,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    hintText: l10n.messageInputHint,
                    helperText: l10n.messageChatComingSoon,
                    disabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                      borderSide: BorderSide(color: AppColors.borderStrong),
                    ),
                  ),
                ),
              ),
              IconButton.filled(
                tooltip: '${l10n.messageSendAudio} (${l10n.comingSoon})',
                onPressed: null,
                style: IconButton.styleFrom(
                  minimumSize: const Size.square(52),
                  disabledBackgroundColor: AppColors.borderStrong,
                  disabledForegroundColor: AppColors.surface,
                ),
                icon: const Icon(Icons.mic_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
