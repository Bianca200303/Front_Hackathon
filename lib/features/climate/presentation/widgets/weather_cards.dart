import 'package:flutter/material.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/theme/app_palette.dart';
import 'package:siembra_segura/core/theme/app_spacing.dart';
import 'package:siembra_segura/core/theme/app_typography.dart';
import 'package:siembra_segura/core/utils/formatters.dart';
import 'package:siembra_segura/features/climate/domain/climate_overview.dart';
import 'package:siembra_segura/features/climate/presentation/climate_labels.dart';
import 'package:siembra_segura/shared/widgets/app_card.dart';
import 'package:siembra_segura/shared/widgets/text_blocks.dart';

/// Tarjeta azul con el clima de hoy (`.hoy`).
class TodayWeatherCard extends StatelessWidget {
  /// Crea la tarjeta.
  const TodayWeatherCard({required this.today, super.key});

  /// El tiempo de hoy.
  final TodayWeather today;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final onWater = context.colors.onPrimary;
    return MergeSemantics(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: context.colors.water,
          borderRadius: AppRadii.card,
        ),
        child: Row(
          spacing: 14,
          children: [
            ExcludeSemantics(
              child: Icon(today.condition.icon, size: 44, color: onWater),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.climateToday(AppFormatters.weekday(today.date)),
                    style: context.text.muted.copyWith(
                      color: onWater.withValues(alpha: 0.9),
                    ),
                  ),
                  Text(
                    today.condition.label(l10n),
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: onWater),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    l10n.climateTodayDetails(
                      AppFormatters.percent(today.rainProbability),
                      AppFormatters.millimeters(today.rainMm),
                      AppFormatters.celsius(today.temperatureC),
                    ),
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: onWater),
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

/// Pronóstico de 7 días (`.semana`).
class WeekForecastCard extends StatelessWidget {
  /// Crea la tarjeta.
  const WeekForecastCard({
    required this.week,
    required this.heavyRainDay,
    super.key,
  });

  /// Pronóstico de los próximos días.
  final List<DailyForecast> week;

  /// Día de lluvia fuerte a destacar, si hay.
  final DailyForecast? heavyRainDay;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final stormDay = heavyRainDay;
    return AppCard(
      children: [
        SectionTitle(l10n.climateThisWeek),
        _WeekGrid(week: week),
        if (stormDay != null)
          Builder(
            builder: (context) {
              final weekday = AppFormatters.weekday(stormDay.date);
              return HighlightedText(
                text: l10n.climateHeavyRainDay(weekday),
                highlight: weekday,
                style: Theme.of(context).textTheme.bodyMedium,
              );
            },
          ),
      ],
    );
  }
}

/// En pantallas angostas o con texto grande, la grilla pasa a desplazarse
/// horizontalmente para no cortar los textos.
class _WeekGrid extends StatelessWidget {
  const _WeekGrid({required this.week});

  final List<DailyForecast> week;

  static const _gap = AppSpacing.xs;
  static const _baseMinTileWidth = 42.0;

  @override
  Widget build(BuildContext context) {
    final minTileWidth = MediaQuery.textScalerOf(
      context,
    ).scale(_baseMinTileWidth);
    return LayoutBuilder(
      builder: (context, constraints) {
        final available =
            (constraints.maxWidth - _gap * (week.length - 1)) / week.length;
        final fits = available >= minTileWidth;
        final tiles = [for (final day in week) _DayTile(day: day)];

        if (fits) {
          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: _gap,
              children: [for (final tile in tiles) Expanded(child: tile)],
            ),
          );
        }
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: _gap,
              children: [
                for (final tile in tiles)
                  SizedBox(width: minTileWidth, child: tile),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DayTile extends StatelessWidget {
  const _DayTile({required this.day});

  final DailyForecast day;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final background = day.isHeavyRain
        ? context.colors.waterStrongTone.background
        : day.isRainy
        ? context.colors.waterTone.background
        : context.colors.surfaceSubtle;
    final detailStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
      color: day.isHeavyRain ? context.colors.water : context.colors.textMuted,
      fontWeight: day.isHeavyRain ? FontWeight.w800 : FontWeight.w400,
    );

    return MergeSemantics(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
          horizontal: AppSpacing.xxs,
        ),
        decoration: BoxDecoration(
          color: background,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          spacing: AppSpacing.xs,
          children: [
            Text(
              AppFormatters.shortWeekday(day.date),
              style: context.text.captionStrong,
            ),
            // Una sola palabra por línea: si no cabe ("Cloudy" en una
            // columna angosta), se achica en vez de partirse en dos.
            _OneLine(day.condition.shortLabel(l10n), style: detailStyle),
            _OneLine(AppFormatters.millimeters(day.rainMm), style: detailStyle),
          ],
        ),
      ),
    );
  }
}

/// Texto de una línea que se achica si no cabe, sin partir palabras.
class _OneLine extends StatelessWidget {
  const _OneLine(this.text, {this.style});

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(text, style: style, maxLines: 1, softWrap: false),
    );
  }
}
