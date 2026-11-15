import 'package:flutter/material.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/theme/app_palette.dart';
import 'package:siembra_segura/core/theme/app_spacing.dart';
import 'package:siembra_segura/core/theme/app_typography.dart';
import 'package:siembra_segura/core/utils/formatters.dart';
import 'package:siembra_segura/features/crop_planning/domain/crop_planning_models.dart';
import 'package:siembra_segura/features/crop_planning/domain/recommendation.dart';
import 'package:siembra_segura/features/crop_planning/presentation/crop_planning_texts.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';
import 'package:siembra_segura/shared/presentation/vocabulary_labels.dart';
import 'package:siembra_segura/shared/widgets/app_card.dart';
import 'package:siembra_segura/shared/widgets/explainer_tile.dart';
import 'package:siembra_segura/shared/widgets/status_pill.dart';
import 'package:siembra_segura/shared/widgets/text_blocks.dart';

/// "Tu tierra hoy": estado, medidor y hallazgos.
class SoilHealthCard extends StatelessWidget {
  /// Crea la tarjeta.
  const SoilHealthCard({required this.soilHealth, super.key});

  /// Estado de la tierra.
  final SoilHealth soilHealth;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final condition = soilHealth.condition;
    return AppCard(
      children: [
        OverlineText(l10n.rotationSoilToday),
        Semantics(
          label: l10n.rotationSoilGaugeSemantics(condition.label(l10n)),
          excludeSemantics: true,
          child: Row(
            spacing: 14,
            children: [
              // Flexible: con texto grande el estado puede partirse en dos
              // líneas en vez de desbordar.
              Flexible(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 96),
                  child: Text(
                    condition.label(l10n),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: condition.tone(context.colors).foreground,
                    ),
                  ),
                ),
              ),
              Expanded(child: SoilGauge(condition: condition)),
            ],
          ),
        ),
        BulletList(items: soilHealth.findings),
        ExplainerTile(
          title: l10n.whatDoesItMean,
          framed: false,
          children: [
            TermDefinition(
              term: l10n.rotationExplainerGreennessTerm,
              definition: l10n.rotationExplainerGreennessBody,
            ),
            TermDefinition(
              term: l10n.rotationExplainerOrganicMatterTerm,
              definition: l10n.rotationExplainerOrganicMatterBody,
            ),
          ],
        ),
      ],
    );
  }
}

/// Medidor de 3 segmentos (`.medidor`).
class SoilGauge extends StatelessWidget {
  /// Crea el medidor.
  const SoilGauge({required this.condition, super.key});

  /// Estado a representar.
  final SoilCondition condition;

  @override
  Widget build(BuildContext context) {
    final (litSegments, color) = switch (condition) {
      SoilCondition.veryTired ||
      SoilCondition.tired => (1, context.colors.soilGaugeLow),
      SoilCondition.regular => (2, context.colors.soilGaugeMid),
      SoilCondition.good => (3, context.colors.soilGaugeHigh),
    };
    return Row(
      spacing: AppSpacing.xs,
      children: [
        for (var i = 0; i < 3; i++)
          Expanded(
            child: Container(
              height: 12,
              decoration: BoxDecoration(
                color: i < litSegments ? color : context.colors.surfaceMuted,
                borderRadius: const BorderRadius.all(Radius.circular(6)),
              ),
            ),
          ),
      ],
    );
  }
}

/// Papel de una opción en la comparación.
enum OptionKind {
  /// Lo que siembra hoy.
  current,

  /// La rotación recomendada.
  recommended,

  /// Otra alternativa.
  other,
}

/// Tarjeta para comparar una opción (`.opcion`).
class OptionComparisonCard extends StatelessWidget {
  /// Crea la tarjeta con valores explícitos.
  const OptionComparisonCard({
    required this.kind,
    required this.name,
    required this.expectedHarvest,
    required this.waterUseM3,
    required this.soilInTwoYears,
    required this.factsheet,
    super.key,
  });

  /// Tarjeta de lo que el agricultor siembra hoy.
  factory OptionComparisonCard.current(
    Recommendation recommendation,
    AppLocalizations l10n,
  ) {
    final current = recommendation.currentPractice;
    return OptionComparisonCard(
      kind: OptionKind.current,
      name: current.name(l10n),
      expectedHarvest: current.expectedHarvest[recommendation.scenario] ?? 0,
      waterUseM3: current.waterUseM3,
      soilInTwoYears: current.soilInTwoYears,
      factsheet: current.factsheet,
    );
  }

  /// Tarjeta de una rotación; [recommended] la destaca.
  factory OptionComparisonCard.rotation(
    RotationOption option,
    Recommendation recommendation,
    AppLocalizations l10n, {
    required bool recommended,
  }) {
    return OptionComparisonCard(
      kind: recommended ? OptionKind.recommended : OptionKind.other,
      name: option.name(l10n),
      expectedHarvest: option
          .outcomeFor(recommendation.scenario)
          .expectedHarvest,
      waterUseM3: option.waterUseM3,
      soilInTwoYears: option.soilInTwoYears,
      factsheet: option.factsheet,
    );
  }

  /// Tipo de opción (define la etiqueta y el borde).
  final OptionKind kind;

  /// Nombre de la rotación.
  final String name;

  /// Cosecha esperada (1 = una buena campaña).
  final double expectedHarvest;

  /// Agua por hectárea, en m³.
  final int waterUseM3;

  /// Estado de la tierra en dos años.
  final SoilCondition soilInTwoYears;

  /// Ficha explicativa desplegable.
  final OptionFactsheet factsheet;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isRecommended = kind == OptionKind.recommended;
    final (label, tone) = switch (kind) {
      OptionKind.current => (l10n.optionCurrent, context.colors.neutralTone),
      OptionKind.recommended => (
        l10n.optionRecommended,
        Tone(context.colors.primary, context.colors.onPrimary),
      ),
      OptionKind.other => (l10n.optionOther, context.colors.neutralTone),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: AppRadii.card,
        border: isRecommended
            ? Border.all(color: context.colors.primary, width: 2)
            : Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          StatusPill(label: label, tone: tone, dense: true),
          Text(name, style: context.text.cardTitle),
          Row(
            spacing: AppSpacing.sm,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Metric(
                label: l10n.metricExpectedHarvest,
                child: _MetricValue(AppFormatters.percent(expectedHarvest)),
              ),
              _Metric(
                label: l10n.metricWater,
                child: _MetricValue(AppFormatters.cubicMeters(waterUseM3)),
              ),
              _Metric(
                label: l10n.metricSoilInTwoYears,
                child: StatusPill(
                  label: soilInTwoYears.label(l10n),
                  tone: soilInTwoYears.tone(context.colors),
                ),
              ),
            ],
          ),
          ExplainerTile(
            title: l10n.factsheetToggle,
            framed: false,
            children: [
              _FactsheetSection(l10n.factsheetWhy, factsheet.rationale),
              _FactsheetSection(l10n.factsheetEvidence, factsheet.evidence),
              _FactsheetSection(l10n.factsheetBenefits, factsheet.benefits),
              _FactsheetSection(l10n.factsheetUnknowns, factsheet.unknowns),
              _FactsheetSection(l10n.factsheetRisks, factsheet.risks),
            ],
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MergeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.xxs,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodySmall),
            child,
          ],
        ),
      ),
    );
  }
}

class _MetricValue extends StatelessWidget {
  const _MetricValue(this.value);

  final String value;

  @override
  Widget build(BuildContext context) {
    return Text(value, style: context.text.metricValue);
  }
}

class _FactsheetSection extends StatelessWidget {
  const _FactsheetSection(this.title, this.body);

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xs),
      child: MergeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.xxs,
          children: [
            Text(title, style: Theme.of(context).textTheme.labelMedium),
            Text(body, style: context.text.bodyCompact),
          ],
        ),
      ),
    );
  }
}

/// "Plan recomendado: próximas campañas".
class LongTermPlanCard extends StatelessWidget {
  /// Crea la tarjeta.
  const LongTermPlanCard({required this.recommendation, super.key});

  /// Recomendación con el plan.
  final Recommendation recommendation;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final steps = recommendation.best.longTermPlan;
    return AppCard(
      children: [
        SectionTitle(l10n.rotationPlanTitle),
        MutedText(recommendation.longTermPlanName(l10n)),
        Column(
          children: [
            for (final (index, step) in steps.indexed) ...[
              if (index > 0) const Divider(),
              _CampaignRow(step: step),
            ],
          ],
        ),
      ],
    );
  }
}

class _CampaignRow extends StatelessWidget {
  const _CampaignRow({required this.step});

  final CampaignStep step;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return MergeSemantics(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          spacing: 10,
          children: [
            SizedBox(
              width: MediaQuery.textScalerOf(context).scale(76),
              child: Text(
                periodLabel(step.start, step.end),
                style: context.text.captionMuted,
              ),
            ),
            // Si no caben juntos, el estado de la tierra baja a otra línea
            // en vez de cortar el nombre del cultivo.
            Expanded(
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10,
                runSpacing: AppSpacing.sm,
                children: [
                  ColoredBlock(
                    label: step.crop.name,
                    tone: step.crop.tone(context.colors),
                  ),
                  StatusPill(
                    label: l10n.soilWithLabel(
                      step.soilAfter.label(l10n).toLowerCase(),
                    ),
                    tone: step.soilAfter.tone(context.colors),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
