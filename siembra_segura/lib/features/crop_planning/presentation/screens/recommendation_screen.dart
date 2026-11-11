import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/router/app_routes.dart';
import 'package:siembra_segura/features/crop_planning/presentation/crop_planning_texts.dart';
import 'package:siembra_segura/features/crop_planning/presentation/providers/crop_planning_providers.dart';
import 'package:siembra_segura/features/crop_planning/presentation/widgets/recommendation_cards.dart';
import 'package:siembra_segura/shared/widgets/app_button.dart';
import 'package:siembra_segura/shared/widgets/async_value_view.dart';
import 'package:siembra_segura/shared/widgets/farm_settings_button.dart';
import 'package:siembra_segura/shared/widgets/screen_layout.dart';
import 'package:siembra_segura/shared/widgets/text_blocks.dart';

/// Pantalla 2: ¿Qué me conviene sembrar?
class RecommendationScreen extends ConsumerWidget {
  /// Crea la pantalla.
  const RecommendationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final recommendation = ref.watch(recommendationProvider);
    final current = recommendation.value;

    return ScreenLayout(
      header: ScreenHeader(
        actions: const [FarmSettingsButton()],
        title: l10n.recommendationTitle,
        listenText: current != null && current.hasOptions
            ? current.recommendationNarration(l10n)
            : null,
      ),
      body: AsyncValueView(
        value: recommendation,
        onRetry: () => retryRecommendation(ref),
        isEmpty: (recommendation) => !recommendation.hasOptions,
        emptyMessage: l10n.emptyRecommendation,
        data: (recommendation) => ScreenContent(
          children: [
            SeasonalOutlookCard(outlook: recommendation.outlook),
            PriorityContextRow(priority: recommendation.priority),
            RecommendedOptionCard(recommendation: recommendation),
            RepeatCropCard(recommendation: recommendation),
            AppButton(
              label: l10n.actionCompareOptions,
              variant: AppButtonVariant.outline,
              onPressed: () => context.go(AppRoutes.rotation),
            ),
            ScenarioExplorer(selected: recommendation.scenario),
            const GuideDisclaimer(),
          ],
        ),
      ),
    );
  }
}
