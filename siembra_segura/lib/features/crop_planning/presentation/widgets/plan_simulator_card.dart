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
import 'package:siembra_segura/features/crop_planning/presentation/widgets/plan_blocks.dart';
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
  bool _running = false;

  /// Cultivo elegido en la grilla, a poner en la siembra que se toque.
  Crop? _chosen;

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
    final result = await run(_plan);
    if (!mounted) return;
    setState(() {
      _running = false;
      _result = result;
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
    final crops = ref.watch(simulationCropsProvider).value ?? const [];
    final restrictions = ref.watch(
      campaignContextProvider.select((c) => c.restrictionIds),
    );

    // `#r-campanas` y `#r-cultivos` de `semi_app.html`: se toca un cultivo y
    // luego la siembra donde va. Tocar una siembra sin cultivo elegido abre
    // la lista (para quien no descubre los dos pasos).
    return AppCard(
      children: [
        MutedText(l10n.simPickHint),
        LayoutBuilder(
          builder: (context, constraints) {
            final scale = MediaQuery.textScalerOf(context).scale(1);
            final columns = constraints.maxWidth >= 340 * scale ? 4 : 2;
            final width = (constraints.maxWidth - 6 * (columns - 1)) / columns;
            return Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final (index, step) in steps.indexed)
                  SizedBox(
                    width: width,
                    child: _CampaignSlot(
                      period: periodLabel(step.start, step.end),
                      crop: _plan[index],
                      target: _chosen != null,
                      active: _reveal.isAnimating && index == revealed - 1,
                      outcome: result != null && index < revealed
                          ? result.campaigns[index]
                          : null,
                      onTap: _running
                          ? null
                          : () {
                              final chosen = _chosen;
                              if (chosen != null) {
                                _setCrop(index, chosen);
                                setState(() => _chosen = null);
                              } else {
                                unawaited(
                                  _pickCrop(
                                    index,
                                    periodLabel(step.start, step.end),
                                  ),
                                );
                              }
                            },
                    ),
                  ),
              ],
            );
          },
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            final scale = MediaQuery.textScalerOf(context).scale(1);
            final columns = constraints.maxWidth >= 300 * scale ? 3 : 2;
            final width = (constraints.maxWidth - 6 * (columns - 1)) / columns;
            return Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final option in crops)
                  SizedBox(
                    width: width,
                    child: _CropTile(
                      crop: option.crop,
                      selected: option.crop == _chosen,
                      blocked: option.excludedBy
                          .intersection(restrictions)
                          .isNotEmpty,
                      onTap: () => setState(
                        () => _chosen = _chosen == option.crop
                            ? null
                            : option.crop,
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
        if (finished) ...[
          // Igual que las otras opciones, para comparar a simple vista.
          OptionRow(
            kind: OptionRowKind.mine,
            crops: _plan,
            harvest: result.averageHarvest,
            waterM3: result.waterUseM3 ~/ _plan.length,
            soil: result.soilAfter,
          ),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: ListenButton(
              text: l10n.simNarration(
                result.soilAfter.label(l10n).toLowerCase(),
                AppFormatters.percent(result.averageHarvest),
                AppFormatters.cubicMeters(result.waterUseM3 ~/ _plan.length),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Una siembra del plan (`.slot`): color del cultivo, periodo arriba y, al
/// simular, su resultado.
class _CampaignSlot extends StatelessWidget {
  const _CampaignSlot({
    required this.period,
    required this.crop,
    required this.target,
    required this.active,
    required this.outcome,
    required this.onTap,
  });

  final String period;
  final Crop crop;

  /// Hay un cultivo elegido: la siembra se marca como destino.
  final bool target;

  /// Es la que se está mostrando al simular.
  final bool active;
  final SimulatedCampaign? outcome;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final tone = crop.tone(colors);
    final outcome = this.outcome;
    final harvest = outcome?.harvest;
    final result = outcome == null
        ? null
        : harvest == null
        ? l10n.simGreenManureStep
        : l10n.simHarvestStep(AppFormatters.percent(harvest));
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(6),
      side: active
          ? BorderSide(color: colors.focus, width: 3)
          : target
          ? BorderSide(color: colors.primary, width: 2)
          : BorderSide.none,
    );
    return Semantics(
      button: true,
      label: [?result, l10n.simSlotSemantics(period, crop.name)].join('. '),
      excludeSemantics: true,
      onTap: onTap,
      child: Material(
        color: tone.background,
        shape: shape,
        child: InkWell(
          customBorder: shape,
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 92),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(2, 6, 2, 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 4,
                children: [
                  Text(
                    period,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: tone.foreground.withValues(alpha: 0.7),
                    ),
                  ),
                  Text(
                    crop.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: tone.foreground,
                    ),
                  ),
                  if (result != null)
                    Text(
                      result,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: harvest == null || harvest >= 0.8
                            ? const Color(0xFF14532D)
                            : const Color(0xFF8F1B13),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Un cultivo de la grilla (`.cultivo`).
class _CropTile extends StatelessWidget {
  const _CropTile({
    required this.crop,
    required this.selected,
    required this.blocked,
    required this.onTap,
  });

  final Crop crop;
  final bool selected;
  final bool blocked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tone = crop.tone(colors);
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(6),
      side: selected
          ? BorderSide(color: tone.foreground, width: 2)
          : BorderSide.none,
    );
    return Semantics(
      button: true,
      selected: selected,
      enabled: !blocked,
      child: Opacity(
        opacity: blocked ? 0.4 : 1,
        child: Material(
          color: tone.background,
          shape: shape,
          child: InkWell(
            customBorder: shape,
            onTap: blocked ? null : onTap,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 48),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 8,
                  ),
                  child: Text(
                    crop.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: tone.foreground,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

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
