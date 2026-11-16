import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/router/app_routes.dart';
import 'package:siembra_segura/features/crop_planning/presentation/crop_planning_texts.dart';
import 'package:siembra_segura/features/crop_planning/presentation/providers/crop_planning_providers.dart';
import 'package:siembra_segura/features/crop_planning/presentation/widgets/plan_blocks.dart';
import 'package:siembra_segura/features/crop_planning/presentation/widgets/recommendation_cards.dart';
import 'package:siembra_segura/shared/widgets/app_button.dart';
import 'package:siembra_segura/shared/widgets/app_settings.dart';
import 'package:siembra_segura/shared/widgets/async_value_view.dart';
import 'package:siembra_segura/shared/widgets/expandable.dart';
import 'package:siembra_segura/shared/widgets/screen_layout.dart';
import 'package:siembra_segura/shared/widgets/semi/semi_guide.dart';
import 'package:siembra_segura/shared/widgets/semi/semi_painter.dart';
import 'package:siembra_segura/shared/widgets/text_blocks.dart';

/// "Qué sembrar" (`#v-sembrar` de `semi_app.html`): la recomendación con su
/// franja de siembras, cuándo decidir y por qué.
class RecommendationScreen extends ConsumerWidget {
  /// Crea la pantalla.
  const RecommendationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final recommendation = ref.watch(recommendationProvider);
    final current = recommendation.value;

    return ScreenLayout(
      guide: SemiGuide(
        message: current != null && current.hasOptions
            ? l10n.semiPlantSay(
                current.priority.phrase,
                current.best.name(l10n).toLowerCase(),
              )
            : l10n.semiRecommendationGuide,
        expression: SemiExpression.celebrating,
      ),
      header: ScreenHeader(
        actions: const [AppSettingsButton()],
        title: l10n.recommendationTitle,
        showListen: false,
      ),
      body: AsyncValueView(
        value: recommendation,
        onRetry: () => retryRecommendation(ref),
        isEmpty: (recommendation) => !recommendation.hasOptions,
        emptyMessage: l10n.emptyRecommendation,
        data: (recommendation) => ScreenContent(
          children: [
            RecommendationBlock(recommendation: recommendation),
            if (recommendation.data.waterAvailability case final water?)
              WaterLightCard(water: water),
            DeadlineBox(
              deadline: recommendation.best.schedule.decisionDeadline,
              onTap: () => context.go(AppRoutes.plantingSchedule),
            ),
            Expandable(
              title: l10n.whyMore,
              child: ReasonsSection(recommendation: recommendation),
            ),
            AppButton(
              label: l10n.actionCompareOptions,
              variant: AppButtonVariant.outline,
              onPressed: () => context.go(AppRoutes.rotation),
            ),
            ScenarioExplorer(
              selected: recommendation.scenario,
              measuredRainNote: recommendation.data.measuredRainNote,
            ),
            const GuideDisclaimer(),
          ],
        ),
      ),
    );
  }
}
