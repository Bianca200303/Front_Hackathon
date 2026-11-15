import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/router/app_routes.dart';
import 'package:siembra_segura/core/theme/app_palette.dart';
import 'package:siembra_segura/core/theme/app_spacing.dart';
import 'package:siembra_segura/core/theme/app_typography.dart';
import 'package:siembra_segura/core/utils/formatters.dart';
import 'package:siembra_segura/features/crop_planning/domain/recommendation.dart';
import 'package:siembra_segura/features/crop_planning/presentation/crop_planning_texts.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';
import 'package:siembra_segura/shared/domain/seasonal_outlook.dart';
import 'package:siembra_segura/shared/presentation/vocabulary_labels.dart';
import 'package:siembra_segura/shared/state/campaign_context_provider.dart';
import 'package:siembra_segura/shared/widgets/app_button.dart';
import 'package:siembra_segura/shared/widgets/app_card.dart';
import 'package:siembra_segura/shared/widgets/explainer_tile.dart';
import 'package:siembra_segura/shared/widgets/selection_controls.dart';
import 'package:siembra_segura/shared/widgets/text_blocks.dart';

/// "Cómo viene tu valle hasta marzo", con la probabilidad de cada escenario.
class SeasonalOutlookCard extends StatelessWidget {
  /// Crea la tarjeta.
  const SeasonalOutlookCard({required this.outlook, super.key});

  /// Pronóstico a mostrar.
  final SeasonalOutlook outlook;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final mostLikely = outlook.mostLikely.label(l10n).toLowerCase();
    return AppCard(
      children: [
        OverlineText(
          l10n.recommendationOutlookOverline(
            AppFormatters.monthName(outlook.horizonEnd).toUpperCase(),
          ),
          color: context.colors.amber,
        ),
        HighlightedText(
          text: l10n.recommendationMostLikely(mostLikely),
          highlight: mostLikely,
          style: Theme.of(context).textTheme.titleSmall,
          highlightStyle: TextStyle(color: context.colors.water),
        ),
        Column(
          spacing: AppSpacing.sm,
          children: [
            for (final scenario in ClimateScenario.values)
              _ProbabilityRow(
                label: scenario.label(l10n),
                probability: outlook.probabilityOf(scenario),
                color: scenario.color(context.colors),
              ),
          ],
        ),
        SourceNote(l10n.recommendationOutlookNote),
      ],
    );
  }
}

class _ProbabilityRow extends StatelessWidget {
  const _ProbabilityRow({
    required this.label,
    required this.probability,
    required this.color,
  });

  final String label;
  final double probability;
  final Color color;

  static const _minBarWidth = 64.0;

  @override
  Widget build(BuildContext context) {
    final percent = AppFormatters.percent(probability);
    final scaler = MediaQuery.textScalerOf(context);
    final labelWidth = scaler.scale(118);
    final valueWidth = scaler.scale(40);

    final labelText = Text(label, style: context.text.rowLabel);
    final valueText = Text(
      percent,
      textAlign: TextAlign.right,
      style: Theme.of(context).textTheme.titleSmall,
    );
    final bar = ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(6)),
      child: LinearProgressIndicator(
        value: probability,
        minHeight: 12,
        color: color,
        backgroundColor: context.colors.surfaceMuted,
        semanticsLabel: label,
        semanticsValue: percent,
      ),
    );

    return MergeSemantics(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final fitsInline =
              labelWidth + valueWidth + _minBarWidth + 2 * AppSpacing.sm <=
              constraints.maxWidth;
          if (fitsInline) {
            return Row(
              spacing: AppSpacing.sm,
              children: [
                SizedBox(width: labelWidth, child: labelText),
                Expanded(child: bar),
                SizedBox(width: valueWidth, child: valueText),
              ],
            );
          }
          // Texto grande o pantalla angosta: etiqueta y valor arriba.
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.xs,
            children: [
              Row(
                spacing: AppSpacing.sm,
                children: [
                  Expanded(child: labelText),
                  valueText,
                ],
              ),
              bar,
            ],
          );
        },
      ),
    );
  }
}

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
            style: context.text.muted,
            highlightStyle: context.text.mutedEmphasis,
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

/// Tarjeta destacada con la rotación recomendada y sus resultados.
class RecommendedOptionCard extends StatelessWidget {
  /// Crea la tarjeta.
  const RecommendedOptionCard({required this.recommendation, super.key});

  /// Recomendación a mostrar.
  final Recommendation recommendation;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final best = recommendation.best;
    final outcome = recommendation.bestOutcome;
    final normalHarvest = best
        .outcomeFor(ClimateScenario.normal)
        .expectedHarvest;

    return Semantics(
      liveRegion: true,
      container: true,
      child: AppCard(
        variant: AppCardVariant.highlighted,
        children: [
          OverlineText(
            recommendation.headline(l10n),
            color: context.colors.primary,
          ),
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
                label: l10n.outcomeExpected,
                value: l10n.outcomeExpectedValue(
                  AppFormatters.percent(outcome.expectedHarvest),
                ),
                color: context.colors.positive,
              ),
              _OutcomeLine(
                label: l10n.outcomeWorst,
                value: l10n.outcomeWorstValue(
                  AppFormatters.percent(outcome.worstHarvest),
                ),
                color: context.colors.negative,
              ),
              _OutcomeLine(
                label: l10n.outcomeIfNormal,
                value: l10n.outcomeIfNormalValue(
                  AppFormatters.percent(normalHarvest),
                ),
                color: context.colors.textBody,
              ),
              _OutcomeLine(
                label: l10n.outcomeWater,
                value: best.waterSummary,
                color: context.colors.water,
              ),
              _OutcomeLine(
                label: l10n.outcomeSoil,
                value: best.soilImpact.label(l10n),
                color: context.colors.primary,
              ),
            ],
          ),
          // La cosecha va en % de una buena campaña: no es "por hectárea".
          const SourceNote(''),
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
      ],
    );
  }
}

/// "Explorar otros escenarios".
class ScenarioExplorer extends ConsumerWidget {
  /// Crea el explorador.
  const ScenarioExplorer({required this.selected, super.key});

  /// Escenario seleccionado.
  final ClimateScenario selected;

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
        SegmentedSelector<ClimateScenario>(
          semanticsLabel: l10n.scenarioSelectorSemantics,
          selected: selected,
          options: [
            for (final scenario in ClimateScenario.values)
              (scenario, scenario.optionLabel(l10n)),
          ],
          onChanged: ref.read(campaignContextProvider.notifier).selectScenario,
        ),
      ],
    );
  }
}
