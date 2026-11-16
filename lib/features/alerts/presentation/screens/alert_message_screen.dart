import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/router/app_routes.dart';
import 'package:siembra_segura/core/theme/app_palette.dart';
import 'package:siembra_segura/core/theme/app_spacing.dart';
import 'package:siembra_segura/core/utils/clock.dart';
import 'package:siembra_segura/core/utils/formatters.dart';
import 'package:siembra_segura/features/alerts/domain/alert.dart';
import 'package:siembra_segura/features/alerts/presentation/alert_texts.dart';
import 'package:siembra_segura/features/alerts/presentation/providers/alerts_providers.dart';
import 'package:siembra_segura/features/alerts/presentation/widgets/message_widgets.dart';
import 'package:siembra_segura/shared/state/campaign_context_provider.dart';
import 'package:siembra_segura/shared/widgets/app_button.dart';
import 'package:siembra_segura/shared/widgets/async_value_view.dart';
import 'package:siembra_segura/shared/widgets/constrained_content.dart';
import 'package:siembra_segura/shared/widgets/text_blocks.dart';

/// Pantalla 4b: mensaje completo de un aviso.
class AlertMessageScreen extends ConsumerWidget {
  /// Crea la pantalla del aviso [alertId].
  const AlertMessageScreen({required this.alertId, super.key});

  /// Aviso a mostrar.
  final String alertId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final message = ref.watch(alertMessageProvider(alertId));
    return Scaffold(
      backgroundColor: context.colors.chatBackground,
      body: Column(
        children: [
          const ChatHeader(),
          Expanded(
            child: ConstrainedContent(
              child: AsyncValueView(
                value: message,
                onRetry: () => ref.invalidate(alertMessageProvider(alertId)),
                data: (message) => _MessageThread(message: message),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const ConstrainedContent(child: ChatInputBar()),
    );
  }
}

class _MessageThread extends ConsumerWidget {
  const _MessageThread({required this.message});

  final AlertMessage message;

  /// Abre la recomendación en el escenario del aviso.
  void _openWithScenario(BuildContext context, WidgetRef ref, String route) {
    final scenario = message.relatedScenario;
    if (scenario != null) {
      ref.read(campaignContextProvider.notifier).selectScenario(scenario);
    }
    context.go(route);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final now = ref.watch(clockProvider)();
    final sentAt = l10n.messageSentAt(
      relativeDayLabel(message.sentAt, now, l10n, includeTimeToday: false),
      AppFormatters.time(message.sentAt),
    );

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Center(child: _TimeChip(label: sentAt)),
        const SizedBox(height: 10),
        AudioMessageBubble(
          text: message.plainText(),
          duration: message.audioDuration,
        ),
        const SizedBox(height: 10),
        MessageBubble(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.sm,
            children: [
              OverlineText(message.headline, color: context.colors.amber),
              for (final paragraph in message.paragraphs)
                EmphasisText(
                  paragraph,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppButton(
          label: l10n.actionSeeMyRecommendation,
          variant: AppButtonVariant.outline,
          onPressed: () =>
              _openWithScenario(context, ref, AppRoutes.recommendation),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppButton(
          label: l10n.actionWhenToPlant,
          variant: AppButtonVariant.secondary,
          onPressed: () =>
              _openWithScenario(context, ref, AppRoutes.plantingSchedule),
        ),
      ],
    );
  }
}

class _TimeChip extends StatelessWidget {
  const _TimeChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: const BorderRadius.all(Radius.circular(AppRadii.sm)),
      ),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}
