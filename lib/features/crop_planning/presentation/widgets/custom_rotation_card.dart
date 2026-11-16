import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/theme/app_palette.dart';
import 'package:siembra_segura/core/theme/app_spacing.dart';
import 'package:siembra_segura/core/theme/app_typography.dart';
import 'package:siembra_segura/core/utils/formatters.dart';
import 'package:siembra_segura/features/crop_planning/domain/crop_planning_models.dart';
import 'package:siembra_segura/features/crop_planning/domain/recommendation.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';
import 'package:siembra_segura/shared/domain/campaign_catalog.dart';
import 'package:siembra_segura/shared/presentation/vocabulary_labels.dart';
import 'package:siembra_segura/shared/state/campaign_catalog_provider.dart';
import 'package:siembra_segura/shared/state/campaign_context_provider.dart';
import 'package:siembra_segura/shared/widgets/app_card.dart';
import 'package:siembra_segura/shared/widgets/selection_controls.dart';
import 'package:siembra_segura/shared/widgets/status_pill.dart';
import 'package:siembra_segura/shared/widgets/text_blocks.dart';
import 'package:siembra_segura/shared/widgets/warning_note.dart';

/// "Arma tu rotación": el agricultor cambia un cultivo de la secuencia y ve
/// cómo cambian el agua, el riesgo y su tierra.
///
/// Mientras no ha tocado nada muestra la secuencia recomendada; al cambiar
/// un cultivo, el servidor devuelve la secuencia propia como una opción más
/// (`CropPlanningData.customRotationId`).
class CustomRotationCard extends ConsumerWidget {
  /// Crea la tarjeta.
  const CustomRotationCard({required this.recommendation, super.key});

  /// Recomendación vigente, de la que sale la secuencia inicial.
  final Recommendation recommendation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final data = recommendation.data;
    if (data.availableCrops.isEmpty) return const SizedBox.shrink();

    final chosen = ref.watch(
      campaignContextProvider.select((context) => context.customRotation),
    );
    final sequence = chosen.isNotEmpty
        ? chosen
        : [for (final crop in recommendation.best.crops) crop.id];
    final maxCrops =
        ref.watch(campaignCatalogProvider).value?.maxRotationCrops ??
        CampaignCatalog.defaultMaxRotationCrops;
    final notifier = ref.read(campaignContextProvider.notifier);
    final option = data.customOption;

    Future<void> change(int position) async {
      final choice = await _pickCrop(
        context,
        crops: data.availableCrops,
        canRemove: sequence.length > 1,
      );
      if (choice == null) return;
      final updated = [...sequence];
      if (choice.cropId == null) {
        updated.removeAt(position);
      } else {
        updated[position] = choice.cropId!;
      }
      notifier.selectCustomRotation(updated);
    }

    Future<void> add() async {
      final choice = await _pickCrop(
        context,
        crops: data.availableCrops,
        canRemove: false,
      );
      final cropId = choice?.cropId;
      if (cropId != null) notifier.selectCustomRotation([...sequence, cropId]);
    }

    return AppCard(
      children: [
        SectionTitle(l10n.rotationCustomTitle),
        MutedText(l10n.rotationCustomHint),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final (position, cropId) in sequence.indexed)
              _CropSlot(
                crop: _cropNamed(cropId, data.availableCrops),
                position: position,
                total: sequence.length,
                onTap: () => change(position),
              ),
            if (sequence.length < maxCrops)
              SelectableChip(
                label: l10n.rotationCustomAdd,
                selected: false,
                role: SelectionRole.toggle,
                onTap: add,
              ),
          ],
        ),
        if (option != null)
          _CustomOutcome(option: option, recommendation: recommendation),
        if (chosen.isNotEmpty)
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              icon: const Icon(Icons.restart_alt_rounded),
              label: Text(l10n.rotationCustomClear),
              onPressed: () => notifier.selectCustomRotation(const []),
            ),
          ),
      ],
    );
  }

  /// Lo que pide y lo que deja cada cultivo, para elegir con criterio:
  /// "Poca agua · 3 meses · Abona tu tierra".
  static String? _factsLine(Crop crop, AppLocalizations l10n) {
    final facts = cropFacts(crop, l10n);
    return facts.isEmpty ? null : facts.join(' · ');
  }

  static Crop _cropNamed(String cropId, List<Crop> crops) =>
      crops.where((crop) => crop.id == cropId).firstOrNull ??
      Crop(id: cropId, name: cropId);

  static Future<_CropChoice?> _pickCrop(
    BuildContext context, {
    required List<Crop> crops,
    required bool canRemove,
  }) {
    final l10n = AppLocalizations.of(context);
    return showModalBottomSheet<_CropChoice>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            0,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.sm,
            children: [
              SectionTitle(l10n.rotationCustomPickTitle),
              for (final crop in crops)
                RadioOptionTile(
                  label: crop.name,
                  description: _factsLine(crop, l10n),
                  selected: false,
                  onTap: () =>
                      Navigator.of(context).pop(_CropChoice.crop(crop.id)),
                ),
              if (canRemove)
                TextButton.icon(
                  icon: const Icon(Icons.close_rounded),
                  label: Text(l10n.rotationCustomRemove),
                  onPressed: () =>
                      Navigator.of(context).pop(const _CropChoice.remove()),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Lo que eligió el agricultor en el selector de cultivos.
class _CropChoice {
  const _CropChoice.crop(this.cropId);

  const _CropChoice.remove() : cropId = null;

  /// Cultivo elegido; nulo si pidió quitar el tramo.
  final String? cropId;
}

class _CropSlot extends StatelessWidget {
  const _CropSlot({
    required this.crop,
    required this.position,
    required this.total,
    required this.onTap,
  });

  final Crop crop;
  final int position;
  final int total;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // El chip ya anuncia el cultivo y su estado; se le suma la posición
    // dentro de la secuencia, que es lo único que no se oye.
    return MergeSemantics(
      child: Semantics(
        label: l10n.rotationCustomPositionSemantics(position + 1, total),
        child: SelectableChip(
          label: crop.name,
          selected: true,
          role: SelectionRole.toggle,
          onTap: onTap,
        ),
      ),
    );
  }
}

/// Agua, riesgo y tierra de la secuencia que armó el agricultor.
class _CustomOutcome extends ConsumerWidget {
  const _CustomOutcome({required this.option, required this.recommendation});

  final RotationOption option;
  final Recommendation recommendation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final result = option.resultFor(recommendation.scenario);
    final restrictions = ref.watch(
      campaignContextProvider.select((context) => context.restrictionIds),
    );
    final excluded = !option.isAllowedWith(restrictions);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.sm,
      children: [
        StatusPill(
          label: l10n.optionCustom,
          tone: Tone(context.colors.primary, context.colors.onPrimary),
          dense: true,
        ),
        Row(
          spacing: AppSpacing.sm,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Metric(
              label: l10n.metricWater,
              value: AppFormatters.cubicMeters(result.waterUseM3),
            ),
            _Metric(
              label: l10n.metricClimateRisk,
              value: result.climateRisk.label(l10n),
            ),
            _Metric(
              label: l10n.metricSoilInTwoYears,
              value: option.soilInTwoYears.label(l10n),
            ),
          ],
        ),
        // Reglas que rompe la secuencia (misma familia seguida, siembra
        // fuera de sus meses): un aviso amable, no un error.
        for (final warning in option.warnings) WarningNote(warning),
        if (excluded)
          Text(
            l10n.rotationCustomExcluded,
            style: context.text.captionMuted.copyWith(
              color: context.colors.negative,
            ),
          ),
      ],
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MergeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.xxs,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodySmall),
            Text(value, style: context.text.metricValue),
          ],
        ),
      ),
    );
  }
}
