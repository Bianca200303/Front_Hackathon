import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/router/app_routes.dart';
import 'package:siembra_segura/core/theme/app_colors.dart';
import 'package:siembra_segura/core/theme/app_spacing.dart';
import 'package:siembra_segura/core/theme/app_typography.dart';
import 'package:siembra_segura/core/utils/formatters.dart';
import 'package:siembra_segura/features/crop_planning/domain/recommendation.dart';
import 'package:siembra_segura/features/crop_planning/presentation/crop_planning_texts.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';
import 'package:siembra_segura/shared/presentation/vocabulary_labels.dart';
import 'package:siembra_segura/shared/state/campaign_context_provider.dart';
import 'package:siembra_segura/shared/widgets/app_button.dart';
import 'package:siembra_segura/shared/widgets/app_card.dart';
import 'package:siembra_segura/shared/widgets/explainer_tile.dart';
import 'package:siembra_segura/shared/widgets/selection_controls.dart';
import 'package:siembra_segura/shared/widgets/text_blocks.dart';

/// "Pensando en: cuidar tu agua" + botón para cambiar la prioridad.
class PriorityContextRow extends StatelessWidget {
  /// Crea la fila.
  const PriorityContextRow({required this.priority, super.key});

  /// Prioridad vigente.
  final CampaignPriority priority;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final phrase = priority.phrase;
    return Row(
      spacing: AppSpacing.sm,
      children: [
        Expanded(
          child: HighlightedText(
            text: l10n.recommendationThinkingOf(phrase),
            highlight: phrase,
            style: AppTypography.muted,
            highlightStyle: AppTypography.mutedEmphasis,
          ),
        ),
        SelectableChip(
          label: l10n.actionChange,
          selected: false,
          role: SelectionRole.toggle,
          onTap: () => context.push(AppRoutes.farm),
        ),
      ],
    );
  }
}

/// Tarjeta destacada con la rotación recomendada: agua, riesgo y tierra.
class RecommendedOptionCard extends StatelessWidget {
  /// Crea la tarjeta.
  const RecommendedOptionCard({required this.recommendation, super.key});

  /// Recomendación a mostrar.
  final Recommendation recommendation;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final best = recommendation.best;
    final result = recommendation.bestResult;

    return Semantics(
      liveRegion: true,
      container: true,
      child: AppCard(
        variant: AppCardVariant.highlighted,
        children: [
          OverlineText(recommendation.headline(l10n), color: AppColors.primary),
          Text(
            best.name(l10n),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(
            recommendation.rationale(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 6,
            children: [
              _OutcomeLine(
                label: l10n.outcomeWater,
                value: recommendation.water(),
                color: AppColors.water,
              ),
              _OutcomeLine(
                label: l10n.outcomeClimateRisk,
                value: result.climateRisk.label(l10n).toLowerCase(),
                color: result.climateRisk.tone.foreground,
              ),
              _OutcomeLine(
                label: l10n.outcomeSoil,
                value: best.soilImpact.label(l10n),
                color: AppColors.primary,
              ),
            ],
          ),
          SourceNote(
            l10n.forArea(
              AppFormatters.decimal(recommendation.data.areaHectares),
            ),
            backedByRemote: true,
          ),
          AppButton(
            label: l10n.actionWhenToPlant,
            compact: true,
            onPressed: () => context.go(AppRoutes.plantingSchedule),
          ),
        ],
      ),
    );
  }
}

class _OutcomeLine extends StatelessWidget {
  const _OutcomeLine({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TermDefinition(
      term: label,
      definition: value,
      termColor: color,
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }
}

/// "Si siembras arroz otra vez".
class RepeatCropCard extends StatelessWidget {
  /// Crea la tarjeta.
  const RepeatCropCard({required this.recommendation, super.key});

  /// Recomendación con la práctica actual.
  final Recommendation recommendation;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final crop = recommendation.currentPractice.mainCrop.name;
    return AppCard(
      variant: AppCardVariant.compact,
      children: [
        OverlineText(l10n.recommendationRepeatOverline(crop.toUpperCase())),
        Text(
          recommendation.repeatWarning(),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        _OutcomeLine(
          label: l10n.outcomeWater,
          value: AppFormatters.cubicMeters(
            recommendation.currentResult.waterUseM3,
          ),
          color: AppColors.water,
        ),
      ],
    );
  }
}

/// "Explorar otros escenarios": el agricultor elige el que quiere ver.
class ScenarioExplorer extends ConsumerWidget {
  /// Crea el explorador.
  const ScenarioExplorer({
    required this.selected,
    this.measuredRainNote,
    super.key,
  });

  /// Escenario seleccionado.
  final ClimateScenario selected;

  /// Lluvia que el satélite ya midió sobre la chacra y a qué escenario se
  /// parece. Nula mientras la fuente no la tenga.
  final String? measuredRainNote;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return ExplainerTile(
      title: l10n.recommendationExploreScenarios,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.xs),
          child: Text(
            l10n.recommendationExploreQuestion,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        if (measuredRainNote case final note?)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: _MeasuredRain(note: note),
          ),
        SegmentedSelector<ClimateScenario>(
          semanticsLabel: l10n.scenarioSelectorSemantics,
          selected: selected,
          options: [
            for (final scenario in ClimateScenario.values)
              (scenario, scenario.optionLabel(l10n)),
          ],
          onChanged: ref.read(campaignContextProvider.notifier).selectScenario,
        ),
        Padding(
          padding: const EdgeInsets.only(top: AppSpacing.xs),
          child: SourceNote(
            l10n.recommendationScenarioNote,
            backedByRemote: true,
          ),
        ),
      ],
    );
  }
}

/// La lluvia que el satélite ya midió sobre la chacra, que es el dato que
/// dice a qué escenario se está pareciendo el año.
class _MeasuredRain extends StatelessWidget {
  const _MeasuredRain({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppSpacing.sm,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.water_drop_outlined, color: AppColors.water, size: 20),
        Expanded(
          child: Text(note, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}
