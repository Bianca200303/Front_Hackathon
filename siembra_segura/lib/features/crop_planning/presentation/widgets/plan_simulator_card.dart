import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/theme/app_palette.dart';
import 'package:siembra_segura/core/theme/app_spacing.dart';
import 'package:siembra_segura/core/theme/app_typography.dart';
import 'package:siembra_segura/core/utils/formatters.dart';
import 'package:siembra_segura/features/crop_planning/domain/plan_simulation.dart';
import 'package:siembra_segura/features/crop_planning/domain/recommendation.dart';
import 'package:siembra_segura/features/crop_planning/presentation/crop_planning_texts.dart';
import 'package:siembra_segura/features/crop_planning/presentation/providers/crop_planning_providers.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';
import 'package:siembra_segura/shared/presentation/vocabulary_labels.dart';
import 'package:siembra_segura/shared/state/campaign_catalog_provider.dart';
import 'package:siembra_segura/shared/state/campaign_context_provider.dart';
import 'package:siembra_segura/shared/widgets/app_button.dart';
import 'package:siembra_segura/shared/widgets/app_card.dart';
import 'package:siembra_segura/shared/widgets/listen_button.dart';
import 'package:siembra_segura/shared/widgets/status_pill.dart';
import 'package:siembra_segura/shared/widgets/text_blocks.dart';

/// "Prueba tu propio plan" (`#r-campanas` de `semi_app.html`): el
/// agricultor cambia el cultivo de cada campaña y ve, campaña por campaña,
/// cómo le iría comparado con el plan recomendado.
///
/// Más simple que el prototipo para quien usa poco el celular: se toca la
/// campaña y se elige el cultivo de una lista (en vez de "cultivo y
/// después campaña").
class PlanSimulatorCard extends ConsumerStatefulWidget {
  /// Crea el simulador partiendo del plan de [recommendation].
  const PlanSimulatorCard({required this.recommendation, super.key});

  /// Recomendación con el plan de largo plazo y el clima.
  final Recommendation recommendation;

  @override
  ConsumerState<PlanSimulatorCard> createState() => _PlanSimulatorCardState();
}

class _PlanSimulatorCardState extends ConsumerState<PlanSimulatorCard>
    with SingleTickerProviderStateMixin {
  /// Tiempo para mostrar cada campaña al simular.
  static const _stepTime = Duration(milliseconds: 500);

  late List<Crop> _plan = _recommendedPlan;
  PlanSimulation? _result;
  PlanSimulation? _recommendedResult;
  bool _running = false;

  late final AnimationController _reveal = AnimationController(
    vsync: this,
    duration: _stepTime * widget.recommendation.best.longTermPlan.length,
  )..addListener(() => setState(() {}));

  List<Crop> get _recommendedPlan => [
    for (final step in widget.recommendation.best.longTermPlan) step.crop,
  ];

  bool get _isRecommendedPlan =>
      _plan.indexed.every((entry) => entry.$2 == _recommendedPlan[entry.$1]);

  /// Campañas cuyo resultado ya se ve.
  int get _revealed {
    if (_result == null) return 0;
    if (!_reveal.isAnimating) return _plan.length;
    return (_reveal.value * _plan.length).ceil();
  }

  @override
  void didUpdateWidget(PlanSimulatorCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Otra recomendación (cambió la prioridad o el escenario): se empieza de
    // nuevo desde su plan.
    if (oldWidget.recommendation.best != widget.recommendation.best) {
      _plan = _recommendedPlan;
      _result = null;
    }
  }

  @override
  void dispose() {
    _reveal.dispose();
    super.dispose();
  }

  void _setCrop(int index, Crop crop) {
    setState(() {
      _plan = [..._plan]..[index] = crop;
      _result = null;
    });
  }

  void _resetPlan() => setState(() {
    _plan = _recommendedPlan;
    _result = null;
  });

  Future<void> _simulate() async {
    final simulator = ref.read(planSimulatorProvider);
    final data = widget.recommendation.data;
    Future<PlanSimulation> run(List<Crop> plan) => simulator.simulate(
      plan: plan,
      previousCrop: data.currentPractice.mainCrop,
      soilToday: data.soilHealth.condition,
      firstSeason: widget.recommendation.scenario,
    );

    setState(() => _running = true);
    final results = await Future.wait([run(_plan), run(_recommendedPlan)]);
    if (!mounted) return;
    setState(() {
      _running = false;
      _result = results[0];
      _recommendedResult = results[1];
    });
    if (MediaQuery.disableAnimationsOf(context)) return;
    await _reveal.forward(from: 0);
    if (mounted) setState(() {});
  }

  Future<void> _pickCrop(int index, String period) async {
    final l10n = AppLocalizations.of(context);
    final crops = await ref.read(simulationCropsProvider.future);
    final restrictions = ref.read(campaignContextProvider).restrictionIds;
    final catalog = ref.read(campaignCatalogProvider).value;
    if (!mounted) return;

    String? blockedReason(SimulationCrop option) {
      final blocking = option.excludedBy.intersection(restrictions);
      if (blocking.isEmpty) return null;
      final names = catalog?.restrictions
          .where((r) => blocking.contains(r.id))
          .map((r) => r.name);
      return names == null || names.isEmpty ? null : names.first;
    }

    final chosen = await showModalBottomSheet<Crop>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenGutter,
            0,
            AppSpacing.screenGutter,
            AppSpacing.xxl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.sm,
            children: [
              Semantics(
                header: true,
                child: Text(
                  l10n.simPickTitle(period),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              for (final option in crops)
                _CropOption(
                  crop: option.crop,
                  selected: option.crop == _plan[index],
                  blockedReason: blockedReason(option),
                ),
            ],
          ),
        ),
      ),
    );
    if (chosen != null) _setCrop(index, chosen);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final steps = widget.recommendation.best.longTermPlan;
    final result = _result;
    final revealed = _revealed;
    final finished = result != null && revealed >= _plan.length;

    return AppCard(
      children: [
        SectionTitle(l10n.simTitle),
        MutedText(l10n.simIntro),
        Text(
          l10n.simClimateNote(
            widget.recommendation.scenario.label(l10n).toLowerCase(),
          ),
          style: context.text.caption,
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            final scale = MediaQuery.textScalerOf(context).scale(1);
            final columns = constraints.maxWidth >= 640 * scale
                ? 4
                : constraints.maxWidth >= 260 * scale
                ? 2
                : 1;
            final width =
                (constraints.maxWidth - AppSpacing.sm * (columns - 1)) /
                columns;
            return Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final (index, step) in steps.indexed)
                  SizedBox(
                    width: width,
                    child: _CampaignSlot(
                      period: periodLabel(step.start, step.end),
                      crop: _plan[index],
                      outcome: result != null && index < revealed
                          ? result.campaigns[index]
                          : null,
                      onTap: _running
                          ? null
                          : () => _pickCrop(
                              index,
                              periodLabel(step.start, step.end),
                            ),
                    ),
                  ),
              ],
            );
          },
        ),
        AppButton(
          label: l10n.simRun,
          compact: true,
          onPressed: _running || _reveal.isAnimating ? null : _simulate,
        ),
        if (!_isRecommendedPlan)
          Center(
            child: TextButton.icon(
              icon: const Icon(Icons.restart_alt_rounded),
              label: Text(l10n.simReset),
              onPressed: _resetPlan,
            ),
          ),
        if (finished)
          _SimulationSummary(result: result, recommended: _recommendedResult),
      ],
    );
  }
}

/// Una campaña del plan: periodo, cultivo y, al simular, su resultado.
class _CampaignSlot extends StatelessWidget {
  const _CampaignSlot({
    required this.period,
    required this.crop,
    required this.outcome,
    required this.onTap,
  });

  final String period;
  final Crop crop;
  final SimulatedCampaign? outcome;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final outcome = this.outcome;
    final harvest = outcome?.harvest;
    final shape = RoundedRectangleBorder(
      borderRadius: AppRadii.card,
      side: BorderSide(color: colors.borderStrong),
    );
    final result = outcome == null
        ? null
        : harvest == null
        ? l10n.simGreenManureStep
        : l10n.simHarvestStep(AppFormatters.percent(harvest));
    return Semantics(
      button: true,
      // Un solo anuncio con todo: periodo, cultivo, resultado y qué hacer.
      label: [?result, l10n.simSlotSemantics(period, crop.name)].join('. '),
      excludeSemantics: true,
      onTap: onTap,
      child: Material(
        color: colors.surface,
        shape: shape,
        child: InkWell(
          customBorder: shape,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.sm,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(period, style: context.text.captionMuted),
                    ),
                    Icon(Icons.edit_rounded, size: 18, color: colors.primary),
                  ],
                ),
                ColoredBlock(label: crop.name, tone: crop.tone(colors)),
                if (result != null)
                  Text(
                    result,
                    style: context.text.emphasis.copyWith(
                      color: harvest == null || harvest >= 0.8
                          ? colors.positive
                          : colors.negative,
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

/// Opción de cultivo en la lista para elegir.
class _CropOption extends StatelessWidget {
  const _CropOption({
    required this.crop,
    required this.selected,
    this.blockedReason,
  });

  final Crop crop;
  final bool selected;
  final String? blockedReason;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final reason = blockedReason;
    final enabled = reason == null;
    final shape = RoundedRectangleBorder(
      borderRadius: AppRadii.button,
      side: BorderSide(
        color: selected ? colors.primary : colors.borderStrong,
        width: selected ? 2 : 1,
      ),
    );
    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      enabled: enabled,
      child: Material(
        color: selected ? colors.primarySoft : colors.surface,
        shape: shape,
        child: InkWell(
          customBorder: shape,
          onTap: enabled ? () => Navigator.of(context).pop(crop) : null,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              spacing: AppSpacing.md,
              children: [
                Opacity(
                  opacity: enabled ? 1 : 0.5,
                  child: ColoredBlock(
                    label: crop.name,
                    tone: crop.tone(colors),
                  ),
                ),
                Expanded(
                  child: reason == null
                      ? const SizedBox.shrink()
                      : Text(
                          l10n.simCropUnavailable(reason),
                          style: context.text.muted,
                        ),
                ),
                if (selected)
                  Icon(Icons.check_circle_rounded, color: colors.primary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Resumen al terminar: cosecha, agua y tierra, comparado con el plan
/// recomendado (calculado con las mismas reglas).
class _SimulationSummary extends StatelessWidget {
  const _SimulationSummary({required this.result, required this.recommended});

  final PlanSimulation result;
  final PlanSimulation? recommended;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final harvest = AppFormatters.percent(result.averageHarvest);
    final water = AppFormatters.cubicMeters(result.waterUseM3);
    final soil = result.soilAfter;
    final reference = recommended;
    final narration = l10n.simNarration(
      soil.label(l10n).toLowerCase(),
      harvest,
      water,
    );

    return Semantics(
      liveRegion: true,
      container: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.primarySoft,
          borderRadius: AppRadii.card,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.md,
            children: [
              Text(
                l10n.simResultTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Wrap(
                spacing: AppSpacing.xl,
                runSpacing: AppSpacing.md,
                children: [
                  _Metric(label: l10n.metricExpectedHarvest, value: harvest),
                  _Metric(label: l10n.simWaterTotal, value: water),
                  _Metric(
                    label: l10n.metricSoilInTwoYears,
                    child: StatusPill(
                      label: soil.label(l10n),
                      tone: soil.tone(colors),
                    ),
                  ),
                ],
              ),
              if (reference != null)
                Text(
                  l10n.simCompare(
                    AppFormatters.percent(reference.averageHarvest),
                    AppFormatters.cubicMeters(reference.waterUseM3),
                    reference.soilAfter.label(l10n).toLowerCase(),
                  ),
                  style: context.text.bodyCompact,
                ),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: ListenButton(text: narration),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, this.value, this.child});

  final String label;
  final String? value;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final text = value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacing.xxs,
      children: [
        Text(label, style: context.text.caption),
        if (text != null) Text(text, style: context.text.metricValue),
        ?child,
      ],
    );
  }
}
