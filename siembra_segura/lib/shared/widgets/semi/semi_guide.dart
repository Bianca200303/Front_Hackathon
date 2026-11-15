import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/theme/app_palette.dart';
import 'package:siembra_segura/core/theme/app_spacing.dart';
import 'package:siembra_segura/core/theme/app_typography.dart';
import 'package:siembra_segura/shared/domain/app_mode.dart';
import 'package:siembra_segura/shared/state/app_mode_provider.dart';
import 'package:siembra_segura/shared/widgets/listen_button.dart';
import 'package:siembra_segura/shared/widgets/selection_controls.dart';
import 'package:siembra_segura/shared/widgets/semi/semi_avatar.dart';
import 'package:siembra_segura/shared/widgets/semi/semi_painter.dart';

/// Parte superior de cada pantalla: el selector de modo, siempre visible,
/// y debajo Semi presentando la pantalla (solo en [AppMode.assisted]).
///
/// Con poco alto (teléfono en horizontal) o letra grande, Semi se muestra
/// compacto: solo la cabeza y dos líneas; al tocarlo se ve el mensaje
/// completo.
class SemiGuide extends ConsumerStatefulWidget {
  /// Crea la guía con lo que Semi dice en esta pantalla.
  const SemiGuide({
    required this.message,
    this.expression = SemiExpression.happy,
    super.key,
  });

  /// Por debajo de este alto de ventana, la guía es compacta.
  static const compactBelowHeight = 600.0;

  /// Por encima de esta escala de texto, la guía es compacta.
  static const compactAboveTextScale = 1.3;

  /// Lo que dice Semi (también lo lee en voz alta).
  final String message;

  /// Cómo se ve Semi mientras lo dice.
  final SemiExpression expression;

  @override
  ConsumerState<SemiGuide> createState() => _SemiGuideState();
}

class _SemiGuideState extends ConsumerState<SemiGuide> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final mode = ref.watch(appModeProvider);
    final compact =
        MediaQuery.sizeOf(context).height < SemiGuide.compactBelowHeight ||
        MediaQuery.textScalerOf(context).scale(1) >
            SemiGuide.compactAboveTextScale;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenGutter,
        0,
        AppSpacing.screenGutter,
        AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SegmentedSelector<AppMode>(
            semanticsLabel: l10n.appModeSwitchSemantics,
            selected: mode,
            options: [
              (AppMode.assisted, l10n.appModeAssistedTitle),
              (AppMode.manual, l10n.appModeManualTitle),
            ],
            onChanged: (mode) =>
                unawaited(ref.read(appModeProvider.notifier).select(mode)),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            alignment: Alignment.topCenter,
            child: mode != AppMode.assisted
                ? const SizedBox(width: double.infinity)
                : Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.sm),
                    child: SemiGuideCard(
                      message: widget.message,
                      expression: widget.expression,
                      compact: compact,
                      onExpand: compact
                          ? () => _showFullMessage(context)
                          : null,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _showFullMessage(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: context.colors.semiGuideBackground,
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenGutter,
            0,
            AppSpacing.screenGutter,
            AppSpacing.xxl,
          ),
          child: SemiGuideCard(
            message: widget.message,
            expression: widget.expression,
          ),
        ),
      ),
    );
  }
}

/// Tarjeta con Semi y su globo de diálogo, con botón para escucharlo.
class SemiGuideCard extends StatelessWidget {
  /// Crea la tarjeta.
  const SemiGuideCard({
    required this.message,
    this.expression = SemiExpression.happy,
    this.compact = false,
    this.onExpand,
    super.key,
  });

  /// Lo que dice Semi.
  final String message;

  /// Expresión de Semi.
  final SemiExpression expression;

  /// Solo la cabeza de Semi y el mensaje recortado a dos líneas.
  final bool compact;

  /// Si se indica, tocar el globo muestra el mensaje completo.
  final VoidCallback? onExpand;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final avatar = compact
        ? SemiAvatar.head(
            expression: expression,
            size: 44,
            semanticLabel: l10n.semiAvatarSemantics,
          )
        : SemiAvatar(
            expression: expression,
            size: 76,
            semanticLabel: l10n.semiAvatarSemantics,
          );
    const bubbleShape = BorderRadius.only(
      topLeft: Radius.circular(18),
      topRight: Radius.circular(18),
      bottomRight: Radius.circular(18),
      // Esquina casi recta junto a Semi: el globo "sale" de él.
      bottomLeft: Radius.circular(6),
    );
    Widget bubble = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 10,
      ),
      child: Text(
        message,
        maxLines: compact ? 2 : null,
        overflow: compact ? TextOverflow.ellipsis : null,
        style: context.text.bodyCompact.copyWith(
          color: context.colors.textPrimary,
        ),
      ),
    );
    final expand = onExpand;
    if (expand != null) {
      bubble = InkWell(
        borderRadius: bubbleShape,
        onTap: expand,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AppSizes.minTouchTarget),
          child: Align(alignment: Alignment.centerLeft, child: bubble),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: context.colors.semiGuideBackground,
        borderRadius: AppRadii.card,
        border: Border.all(color: context.colors.semiGuideBorder),
      ),
      child: Row(
        crossAxisAlignment: compact
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.end,
        spacing: AppSpacing.sm,
        children: [
          avatar,
          Expanded(
            child: Material(
              color: context.colors.surface,
              borderRadius: bubbleShape,
              child: bubble,
            ),
          ),
          ListenButton(text: message, compact: true),
        ],
      ),
    );
  }
}
