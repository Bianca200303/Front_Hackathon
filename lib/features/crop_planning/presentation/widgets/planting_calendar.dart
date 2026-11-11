import 'package:flutter/material.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/theme/app_colors.dart';
import 'package:siembra_segura/core/theme/app_spacing.dart';
import 'package:siembra_segura/core/utils/formatters.dart';
import 'package:siembra_segura/features/crop_planning/domain/crop_planning_models.dart';
import 'package:siembra_segura/shared/presentation/vocabulary_labels.dart';
import 'package:siembra_segura/shared/widgets/status_pill.dart';

/// Calendario mensual con los cultivos y los meses de riesgo (`.cal`).
class PlantingCalendar extends StatelessWidget {
  /// Crea el calendario.
  const PlantingCalendar({
    required this.schedule,
    required this.riskMonths,
    super.key,
  });

  /// Calendario de la rotación.
  final PlantingSchedule schedule;

  /// Meses a marcar como riesgo.
  final List<DateTime> riskMonths;

  static const _columnGap = AppSpacing.xxs;

  int _monthIndex(DateTime date) =>
      (date.year - schedule.timelineStart.year) * 12 +
      date.month -
      schedule.timelineStart.month;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final months = schedule.months;
    final riskIndexes = riskMonths.map(_monthIndex).toSet();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 6,
      children: [
        ExcludeSemantics(
          child: Row(
            spacing: _columnGap,
            children: [
              for (final month in months)
                Expanded(
                  child: Text(
                    AppFormatters.shortMonth(month),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
        ),
        Row(spacing: _columnGap, children: _periodBlocks(l10n, months.length)),
        if (riskIndexes.isNotEmpty)
          ExcludeSemantics(
            child: Row(
              spacing: _columnGap,
              children: [
                for (var i = 0; i < months.length; i++)
                  Expanded(
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: riskIndexes.contains(i)
                            ? AppColors.water
                            : Colors.transparent,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        if (riskIndexes.isNotEmpty)
          Text(
            l10n.scheduleRiskLegend(
              AppFormatters.capitalize(
                joinWithAnd([
                  for (final month in riskMonths)
                    AppFormatters.monthName(month),
                ], l10n),
              ),
            ),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.water,
            ),
          ),
      ],
    );
  }

  /// Bloques de cultivo con su ancho proporcional a los meses que ocupan.
  /// Los meses sin cultivo quedan como espacio vacío.
  List<Widget> _periodBlocks(AppLocalizations l10n, int totalMonths) {
    final blocks = <Widget>[];
    var cursor = 0;
    for (final period in schedule.periods) {
      final start = _monthIndex(period.start).clamp(0, totalMonths);
      final end = (start + period.monthCount).clamp(0, totalMonths);
      if (start > cursor) blocks.add(Spacer(flex: start - cursor));
      if (end > start) {
        final label = period.crop.name;
        blocks.add(
          Expanded(
            flex: end - start,
            child: Semantics(
              label: l10n.scheduleCalendarSemantics(label, end - start),
              excludeSemantics: true,
              child: ColoredBlock(
                label: label,
                tone: period.crop.tone,
                compact: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: AppSpacing.sm,
                ),
              ),
            ),
          ),
        );
      }
      cursor = end;
    }
    if (cursor < totalMonths) blocks.add(Spacer(flex: totalMonths - cursor));
    return blocks;
  }
}
