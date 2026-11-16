import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/router/app_routes.dart';
import 'package:siembra_segura/core/theme/app_palette.dart';
import 'package:siembra_segura/core/utils/formatters.dart';
import 'package:siembra_segura/features/climate/domain/climate_overview.dart';
import 'package:siembra_segura/features/climate/presentation/climate_labels.dart';
import 'package:siembra_segura/features/climate/presentation/providers/climate_providers.dart';
import 'package:siembra_segura/features/climate/presentation/widgets/anomaly_comparison_card.dart';
import 'package:siembra_segura/features/climate/presentation/widgets/weather_cards.dart';
import 'package:siembra_segura/shared/widgets/app_settings.dart';
import 'package:siembra_segura/shared/widgets/async_value_view.dart';
import 'package:siembra_segura/shared/widgets/expandable.dart';
import 'package:siembra_segura/shared/widgets/notice_tile.dart';
import 'package:siembra_segura/shared/widgets/responsive_columns.dart';
import 'package:siembra_segura/shared/widgets/screen_layout.dart';
import 'package:siembra_segura/shared/widgets/semi/semi_guide.dart';
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
      // Semi resume el día en su globo (y lo lee con "Escuchar").
      guide: SemiGuide(
        message: data == null
            ? l10n.semiClimateGuide
            : '${l10n.semiClimateGuide} ${_narration(data, l10n)}',
      ),
      wide: true,
      header: ScreenHeader(
        actions: [const AppSettingsButton()],
        title: l10n.climateTitle,
        subtitle: data?.valleyName,
        showListen: false,
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
            const _PlanningNotice(),
            // La comparación con otros años, a un toque: la pantalla muestra
            // primero lo que sirve para hoy.
            if (overview.anomalies.isNotEmpty)
              Expandable(
                title: l10n.climateMore,
                child: AnomalyComparisonCard(anomalies: overview.anomalies),
              ),
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

/// Acceso a la recomendación desde Clima.
class _PlanningNotice extends StatelessWidget {
  const _PlanningNotice();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return NoticeTile(
      icon: Icons.calendar_month_outlined,
      iconTone: context.colors.waterTone,
      title: l10n.climatePlanTitle,
      body: l10n.climatePlanAction,
      onTap: () => context.go(AppRoutes.recommendation),
    );
  }
}
