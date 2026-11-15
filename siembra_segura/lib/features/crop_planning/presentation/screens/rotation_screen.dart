import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/theme/app_palette.dart';
import 'package:siembra_segura/core/theme/app_spacing.dart';
import 'package:siembra_segura/features/crop_planning/domain/recommendation.dart';
import 'package:siembra_segura/features/crop_planning/presentation/crop_planning_texts.dart';
import 'package:siembra_segura/features/crop_planning/presentation/providers/crop_planning_providers.dart';
import 'package:siembra_segura/features/crop_planning/presentation/widgets/plan_blocks.dart';
import 'package:siembra_segura/features/crop_planning/presentation/widgets/plan_simulator_card.dart';
import 'package:siembra_segura/shared/widgets/app_settings.dart';
import 'package:siembra_segura/shared/widgets/async_value_view.dart';
import 'package:siembra_segura/shared/widgets/expandable.dart';
import 'package:siembra_segura/shared/widgets/screen_layout.dart';
import 'package:siembra_segura/shared/widgets/semi/semi_guide.dart';
import 'package:siembra_segura/shared/widgets/text_blocks.dart';

/// Pantalla 3: Tu plan de rotación.
class RotationScreen extends ConsumerWidget {
  /// Crea la pantalla.
  const RotationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final recommendation = ref.watch(recommendationProvider);

    return ScreenLayout(
      guide: SemiGuide(message: l10n.semiRotationSay),
      wide: true,
      header: ScreenHeader(
        actions: [const AppSettingsButton()],
        title: l10n.rotationTitle,
        showListen: false,
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
    final r = recommendation;
    final current = r.currentPractice;
    final compared = r.comparedRotations;

    // `#v-rotacion` de `semi_app.html`: tierra de hoy, las opciones como
    // filas con su franja y "Prueba tu propio plan".
    return ScreenContent(
      children: [
        SoilTodaySection(recommendation: r),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.xxs,
          children: [
            SectionTitle(l10n.rotationCompareTitle(r.comparedOptionsCount)),
            MutedText(l10n.compareSubtitle),
          ],
        ),
        // A la vista solo la recomendada; lo demás, a un toque.
        OptionRow(
          kind: OptionRowKind.recommended,
          crops: [for (final s in compared.first.longTermPlan) s.crop],
          harvest: compared.first.outcomeFor(r.scenario).expectedHarvest,
          waterM3: compared.first.waterUseM3,
          soil: compared.first.soilInTwoYears,
          factsheet: compared.first.factsheet,
        ),
        Expandable(
          title: l10n.otherOptionsMore,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              OptionRow(
                kind: OptionRowKind.current,
                crops: List.filled(4, current.mainCrop),
                harvest: current.expectedHarvest[r.scenario] ?? 0,
                waterM3: current.waterUseM3,
                soil: current.soilInTwoYears,
                factsheet: current.factsheet,
              ),
              for (final option in compared.skip(1))
                OptionRow(
                  kind: OptionRowKind.other,
                  crops: [for (final s in option.longTermPlan) s.crop],
                  harvest: option.outcomeFor(r.scenario).expectedHarvest,
                  waterM3: option.waterUseM3,
                  soil: option.soilInTwoYears,
                  factsheet: option.factsheet,
                ),
            ],
          ),
        ),
        Expandable(
          title: l10n.simTitle,
          child: PlanSimulatorCard(recommendation: r),
        ),
        Text(
          l10n.rotationGuideNote,
          style: TextStyle(fontSize: 13, color: context.colors.textMuted),
        ),
        const SourceNote(''),
      ],
    );
  }
}
