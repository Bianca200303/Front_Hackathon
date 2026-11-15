import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/theme/app_spacing.dart';
import 'package:siembra_segura/core/theme/app_typography.dart';
import 'package:siembra_segura/features/crop_planning/domain/recommendation.dart';
import 'package:siembra_segura/features/crop_planning/presentation/crop_planning_texts.dart';
import 'package:siembra_segura/features/crop_planning/presentation/providers/crop_planning_providers.dart';
import 'package:siembra_segura/features/crop_planning/presentation/widgets/custom_rotation_card.dart';
import 'package:siembra_segura/features/crop_planning/presentation/widgets/rotation_cards.dart';
import 'package:siembra_segura/shared/presentation/vocabulary_labels.dart';
import 'package:siembra_segura/shared/widgets/async_value_view.dart';
import 'package:siembra_segura/shared/widgets/farm_settings_button.dart';
import 'package:siembra_segura/shared/widgets/responsive_columns.dart';
import 'package:siembra_segura/shared/widgets/screen_layout.dart';
import 'package:siembra_segura/shared/widgets/text_blocks.dart';

/// Pantalla 3: Tu plan de rotación.
class RotationScreen extends ConsumerWidget {
  /// Crea la pantalla.
  const RotationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final recommendation = ref.watch(recommendationProvider);
    final current = recommendation.value;

    return ScreenLayout(
      wide: true,
      header: ScreenHeader(
        actions: const [FarmSettingsButton()],
        title: l10n.rotationTitle,
        listenText: current != null && current.hasOptions
            ? current.rotationNarration(l10n)
            : null,
      ),
      body: AsyncValueView(
        value: recommendation,
        onRetry: () => retryRecommendation(ref),
        isEmpty: (recommendation) => !recommendation.hasOptions,
        emptyMessage: l10n.emptyRecommendation,
        data: _RotationContent.new,
      ),
    );
  }
}

class _RotationContent extends StatelessWidget {
  const _RotationContent(this.recommendation);

  final Recommendation recommendation;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final priority = recommendation.priority.phrase;
    final compared = recommendation.comparedRotations;

    return ScreenContent(
      children: [
        SoilHealthCard(soilHealth: recommendation.data.soilHealth),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.xxs,
          children: [
            SectionTitle(
              l10n.rotationCompareTitle(recommendation.comparedOptionsCount),
            ),
            HighlightedText(
              text: l10n.rotationCompareSubtitle(
                priority,
                recommendation.scenario.phrase(l10n),
              ),
              highlight: priority,
              style: AppTypography.muted,
              highlightStyle: AppTypography.mutedEmphasis,
            ),
          ],
        ),
        ResponsiveColumns(
          children: [
            OptionComparisonCard.current(recommendation, l10n),
            for (final (index, option) in compared.indexed)
              OptionComparisonCard.rotation(
                option,
                recommendation,
                l10n,
                recommended: index == 0,
              ),
          ],
        ),
        CustomRotationCard(recommendation: recommendation),
        LongTermPlanCard(recommendation: recommendation),
        const GuideDisclaimer(),
        const SourceNote('', backedByRemote: true),
      ],
    );
  }
}
