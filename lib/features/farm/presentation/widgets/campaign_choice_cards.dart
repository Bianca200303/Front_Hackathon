import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/theme/app_spacing.dart';
import 'package:siembra_segura/core/theme/app_typography.dart';
import 'package:siembra_segura/features/farm/domain/farm.dart';
import 'package:siembra_segura/features/farm/presentation/providers/farm_providers.dart';
import 'package:siembra_segura/shared/domain/campaign_catalog.dart';
import 'package:siembra_segura/shared/state/campaign_context_provider.dart';
import 'package:siembra_segura/shared/widgets/app_card.dart';
import 'package:siembra_segura/shared/widgets/selection_controls.dart';
import 'package:siembra_segura/shared/widgets/text_blocks.dart';

/// "¿Qué sembraste la última campaña?": el satélite propone y el agricultor
/// corrige entre las opciones que entrega la parcela.
class LastCropCard extends ConsumerWidget {
  /// Crea la tarjeta para [farm].
  const LastCropCard({required this.farm, super.key});

  /// Parcela con el cultivo inferido y las opciones.
  final Farm farm;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final selected = ref.watch(selectedLastCropProvider(farm));
    final inferred = farm.inferredLastCrop.name;
    final notifier = ref.read(campaignContextProvider.notifier);

    return AppCard(
      children: [
        SectionTitle(l10n.farmLastCropQuestion),
        HighlightedText(
          text: l10n.farmLastCropHint(inferred),
          highlight: inferred,
          style: AppTypography.muted,
          highlightStyle: AppTypography.mutedEmphasis,
        ),
        Semantics(
          label: l10n.farmLastCropGroupSemantics,
          container: true,
          child: Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final crop in farm.lastCropOptions)
                SelectableChip(
                  label: crop.name,
                  selected: crop == selected,
                  onTap: () => notifier.selectLastCrop(crop.id),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// "¿Qué te importa más esta campaña?": una prioridad del catálogo.
class PriorityCard extends ConsumerWidget {
  /// Crea la tarjeta con las prioridades de [catalog].
  const PriorityCard({required this.catalog, super.key});

  /// Catálogo con las prioridades disponibles.
  final CampaignCatalog catalog;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final selectedId = ref.watch(
      campaignContextProvider.select((context) => context.priorityId),
    );
    final selected = catalog.priorityOrDefault(selectedId);
    final notifier = ref.read(campaignContextProvider.notifier);

    return AppCard(
      children: [
        SectionTitle(l10n.farmPriorityQuestion),
        Semantics(
          label: l10n.farmPriorityGroupSemantics,
          container: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.sm,
            children: [
              for (final priority in catalog.priorities)
                RadioOptionTile(
                  label: priority.name,
                  selected: priority == selected,
                  onTap: () => notifier.selectPriority(priority.id),
                ),
            ],
          ),
        ),
        Text(
          l10n.farmPriorityNote,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

/// "¿Hay algo que no puedas hacer? (opcional)": restricciones del catálogo.
class RestrictionsCard extends ConsumerWidget {
  /// Crea la tarjeta con las restricciones de [catalog].
  const RestrictionsCard({required this.catalog, super.key});

  /// Catálogo con las restricciones disponibles.
  final CampaignCatalog catalog;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final active = ref.watch(
      campaignContextProvider.select((context) => context.restrictionIds),
    );
    final notifier = ref.read(campaignContextProvider.notifier);

    return AppCard(
      children: [
        Semantics(
          header: true,
          child: Text.rich(
            TextSpan(
              style: Theme.of(context).textTheme.titleMedium,
              children: [
                TextSpan(text: '${l10n.farmRestrictionsQuestion} '),
                TextSpan(
                  text: l10n.optionalLabel,
                  style: AppTypography.mutedLabel,
                ),
              ],
            ),
          ),
        ),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final restriction in catalog.restrictions)
              SelectableChip(
                label: restriction.name,
                role: SelectionRole.toggle,
                selected: active.contains(restriction.id),
                onTap: () => notifier.toggleRestriction(restriction.id),
              ),
          ],
        ),
      ],
    );
  }
}
