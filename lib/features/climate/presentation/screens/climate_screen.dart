import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/router/app_routes.dart';
import 'package:siembra_segura/core/theme/app_colors.dart';
import 'package:siembra_segura/core/utils/formatters.dart';
import 'package:siembra_segura/features/climate/domain/climate_overview.dart';
import 'package:siembra_segura/features/climate/presentation/climate_labels.dart';
import 'package:siembra_segura/features/climate/presentation/providers/climate_providers.dart';
import 'package:siembra_segura/features/climate/presentation/widgets/anomaly_comparison_card.dart';
import 'package:siembra_segura/features/climate/presentation/widgets/weather_cards.dart';
import 'package:siembra_segura/shared/domain/seasonal_outlook.dart';
import 'package:siembra_segura/shared/presentation/vocabulary_labels.dart';
import 'package:siembra_segura/shared/state/seasonal_outlook_provider.dart';
import 'package:siembra_segura/shared/widgets/async_value_view.dart';
import 'package:siembra_segura/shared/widgets/farm_settings_button.dart';
import 'package:siembra_segura/shared/widgets/notice_tile.dart';
import 'package:siembra_segura/shared/widgets/responsive_columns.dart';
import 'package:siembra_segura/shared/widgets/screen_layout.dart';
import 'package:siembra_segura/shared/widgets/text_blocks.dart';

/// Pantalla 1: Clima.
class ClimateScreen extends ConsumerWidget {
  /// Crea la pantalla.
  const ClimateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final overview = ref.watch(climateOverviewProvider);
    final data = overview.value;

    return ScreenLayout(
      wide: true,
      header: ScreenHeader(
        actions: const [FarmSettingsButton()],
        title: l10n.climateTitle,
        subtitle: data?.valleyName,
        listenText: data == null ? null : _narration(data, l10n),
      ),
      body: AsyncValueView(
        value: overview,
        onRetry: () => ref.invalidate(climateOverviewProvider),
        data: (overview) => ScreenContent(
          onRefresh: () => ref.refresh(climateOverviewProvider.future),
          children: [
            ResponsiveColumns(
              children: [
                TodayWeatherCard(today: overview.today),
                AdviceBox(lead: l10n.climateAdviceLead, text: overview.advice),
              ],
            ),
            WeekForecastCard(
              week: overview.week,
              heavyRainDay: overview.firstHeavyRainDay,
            ),
            const _SeasonalOutlookTile(),
            AnomalyComparisonCard(anomalies: overview.anomalies),
          ],
        ),
      ),
    );
  }

  String _narration(ClimateOverview overview, AppLocalizations l10n) {
    final today = overview.today;
    final stormDay = overview.firstHeavyRainDay;
    return [
      l10n.climateNarration(
        today.condition.label(l10n).toLowerCase(),
        AppFormatters.percent(today.rainProbability),
      ),
      if (stormDay != null)
        l10n.climateHeavyRainDay(AppFormatters.weekday(stormDay.date)),
      AppFormatters.capitalize(overview.advice),
    ].join(' ');
  }
}

/// Acceso a la recomendación desde la perspectiva estacional. Es
/// secundario: si no carga, simplemente no se muestra.
class _SeasonalOutlookTile extends ConsumerWidget {
  const _SeasonalOutlookTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outlook = ref.watch(seasonalOutlookProvider).value;
    if (outlook == null) return const SizedBox.shrink();
    return _OutlookNotice(outlook: outlook);
  }
}

class _OutlookNotice extends StatelessWidget {
  const _OutlookNotice({required this.outlook});

  final SeasonalOutlook outlook;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scenario = outlook.mostLikely;
    return NoticeTile(
      icon: Icons.calendar_month_outlined,
      iconTone: AppColors.waterTone,
      title: l10n.climateOutlookTitle(
        AppFormatters.monthName(outlook.horizonEnd),
        scenario.label(l10n).toLowerCase(),
        AppFormatters.percent(outlook.probabilityOf(scenario)),
      ),
      body: l10n.climateOutlookAction,
      onTap: () => context.go(AppRoutes.recommendation),
    );
  }
}
