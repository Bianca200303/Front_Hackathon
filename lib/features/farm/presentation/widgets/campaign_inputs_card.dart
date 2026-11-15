import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/theme/app_spacing.dart';
import 'package:siembra_segura/core/theme/app_typography.dart';
import 'package:siembra_segura/core/utils/clock.dart';
import 'package:siembra_segura/core/utils/formatters.dart';
import 'package:siembra_segura/features/farm/domain/farm.dart';
import 'package:siembra_segura/features/farm/presentation/providers/farm_providers.dart';
import 'package:siembra_segura/shared/state/campaign_context_provider.dart';
import 'package:siembra_segura/shared/widgets/app_button.dart';
import 'package:siembra_segura/shared/widgets/app_card.dart';
import 'package:siembra_segura/shared/widgets/text_blocks.dart';

/// Lo que el agricultor ingresa de su campaña: hectáreas, cuándo siembra y
/// cuántas campañas seguidas lleva con el mismo cultivo.
///
/// Son las entradas del cálculo del servidor: al cambiarlas se vuelve a
/// pedir la recomendación.
class CampaignInputsCard extends ConsumerWidget {
  /// Crea la tarjeta para [farm].
  const CampaignInputsCard({required this.farm, super.key});

  /// Parcela, para nombrar el cultivo de la última campaña.
  final Farm farm;

  /// Media hectárea: el paso más fino que tiene sentido en la zona piloto.
  static const areaStep = 0.5;

  /// Límite inferior de la superficie, en hectáreas.
  static const minArea = 0.5;

  /// Límite superior de la superficie, en hectáreas.
  static const maxArea = 50.0;

  /// Límite superior de campañas seguidas con el mismo cultivo.
  static const maxCampaigns = 12;

  /// Cuántos meses hacia adelante se puede elegir la fecha de siembra.
  static const monthsAhead = 12;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final notifier = ref.read(campaignContextProvider.notifier);
    final area = ref.watch(selectedAreaHectaresProvider);
    final campaigns = ref.watch(selectedConsecutiveCampaignsProvider);
    final plantingDate = ref.watch(selectedPlantingDateProvider);
    final lastCrop = ref.watch(selectedLastCropProvider(farm)).name;

    return AppCard(
      children: [
        SectionTitle(l10n.farmCampaignTitle),
        _StepperRow(
          question: l10n.farmAreaQuestion,
          value: l10n.farmAreaValue(AppFormatters.decimal(area)),
          decreaseLabel: l10n.farmAreaDecrease,
          increaseLabel: l10n.farmAreaIncrease,
          onDecrease: area > minArea
              ? () => notifier.selectArea(area - areaStep)
              : null,
          onIncrease: area < maxArea
              ? () => notifier.selectArea(area + areaStep)
              : null,
        ),
        _PlantingDateField(date: plantingDate),
        _StepperRow(
          question: l10n.farmCampaignsQuestion(lastCrop.toLowerCase()),
          value: l10n.farmCampaignsValue(campaigns),
          decreaseLabel: l10n.farmCampaignsDecrease,
          increaseLabel: l10n.farmCampaignsIncrease,
          onDecrease: campaigns > 1
              ? () => notifier.selectConsecutiveCampaigns(campaigns - 1)
              : null,
          onIncrease: campaigns < maxCampaigns
              ? () => notifier.selectConsecutiveCampaigns(campaigns + 1)
              : null,
        ),
      ],
    );
  }
}

/// Pregunta con el valor actual entre un botón para restar y otro para
/// sumar. Dos áreas táctiles grandes son más fáciles que escribir un número.
class _StepperRow extends StatelessWidget {
  const _StepperRow({
    required this.question,
    required this.value,
    required this.decreaseLabel,
    required this.increaseLabel,
    required this.onDecrease,
    required this.onIncrease,
  });

  final String question;
  final String value;
  final String decreaseLabel;
  final String increaseLabel;
  final VoidCallback? onDecrease;
  final VoidCallback? onIncrease;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.xs,
      children: [
        Text(question, style: Theme.of(context).textTheme.titleSmall),
        Row(
          spacing: AppSpacing.sm,
          children: [
            _StepButton(
              icon: Icons.remove_rounded,
              tooltip: decreaseLabel,
              onPressed: onDecrease,
            ),
            Expanded(
              child: Semantics(
                label: question,
                value: value,
                excludeSemantics: true,
                child: Text(
                  value,
                  textAlign: TextAlign.center,
                  style: AppTypography.metricValue,
                ),
              ),
            ),
            _StepButton(
              icon: Icons.add_rounded,
              tooltip: increaseLabel,
              onPressed: onIncrease,
            ),
          ],
        ),
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      icon: Icon(icon),
      tooltip: tooltip,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        minimumSize: const Size.square(AppSizes.minTouchTarget),
      ),
    );
  }
}

/// "¿Cuándo quieres sembrar?" con el selector de fechas de Flutter.
class _PlantingDateField extends ConsumerWidget {
  const _PlantingDateField({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    Future<void> pick() async {
      final today = dateOnly(ref.read(clockProvider)());
      final chosen = await showDatePicker(
        context: context,
        // Una fecha guardada en otra sesión puede haber quedado en el
        // pasado; el selector no acepta un inicio anterior a `firstDate`.
        initialDate: date.isBefore(today) ? today : date,
        firstDate: today,
        lastDate: DateTime(
          today.year,
          today.month + CampaignInputsCard.monthsAhead,
          today.day,
        ),
        helpText: l10n.farmPlantingDatePickerTitle,
      );
      if (chosen != null) {
        ref
            .read(campaignContextProvider.notifier)
            .selectPlantingDate(dateOnly(chosen));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.xs,
      children: [
        Text(
          l10n.farmPlantingDateQuestion,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        AppButton(
          label: AppFormatters.dayAndMonth(date),
          variant: AppButtonVariant.outline,
          icon: Icons.calendar_month_outlined,
          onPressed: pick,
        ),
        Text(l10n.farmPlantingDateHint, style: AppTypography.muted),
      ],
    );
  }
}
