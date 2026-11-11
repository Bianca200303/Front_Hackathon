import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/router/app_routes.dart';
import 'package:siembra_segura/core/theme/app_colors.dart';
import 'package:siembra_segura/core/theme/app_spacing.dart';
import 'package:siembra_segura/core/theme/app_typography.dart';
import 'package:siembra_segura/core/utils/formatters.dart';
import 'package:siembra_segura/features/crop_planning/domain/recommendation.dart';
import 'package:siembra_segura/features/crop_planning/presentation/crop_planning_texts.dart';
import 'package:siembra_segura/features/crop_planning/presentation/providers/crop_planning_providers.dart';
import 'package:siembra_segura/features/crop_planning/presentation/widgets/planting_calendar.dart';
import 'package:siembra_segura/features/crop_planning/presentation/widgets/planting_feedback_card.dart';
import 'package:siembra_segura/shared/widgets/app_card.dart';
import 'package:siembra_segura/shared/widgets/async_value_view.dart';
import 'package:siembra_segura/shared/widgets/screen_layout.dart';
import 'package:siembra_segura/shared/widgets/text_blocks.dart';

/// Pantalla 2b: ¿Cuándo siembro?
class PlantingScheduleScreen extends ConsumerWidget {
  /// Crea la pantalla.
  const PlantingScheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final recommendation = ref.watch(recommendationProvider);
    final current = recommendation.value;

    return ScreenLayout(
      header: ScreenHeader.back(
        fallbackLocation: AppRoutes.recommendation,
        listenText: current != null && current.hasOptions
            ? current.scheduleNarration(l10n)
            : null,
      ),
      body: AsyncValueView(
        value: recommendation,
        onRetry: () => retryRecommendation(ref),
        isEmpty: (recommendation) => !recommendation.hasOptions,
        emptyMessage: l10n.emptyRecommendation,
        data: _ScheduleContent.new,
      ),
    );
  }
}

class _ScheduleContent extends StatelessWidget {
  const _ScheduleContent(this.recommendation);

  final Recommendation recommendation;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final best = recommendation.best;
    final schedule = best.schedule;
    final bodyStyle = Theme.of(context).textTheme.bodyMedium;

    return ScreenContent(
      children: [
        ScreenTitle(
          title: l10n.plantingScheduleTitle,
          subtitle: best.name(l10n),
        ),
        _DeadlineBanner(
          deadline: AppFormatters.dayAndMonth(schedule.decisionDeadline),
        ),
        AppCard(
          children: [
            SectionTitle(l10n.scheduleYourCalendar),
            PlantingCalendar(
              schedule: schedule,
              riskMonths: recommendation.riskMonths,
            ),
            Text(schedule.instructions, style: bodyStyle),
            Text.rich(
              TextSpan(
                style: bodyStyle,
                children: [
                  TextSpan(
                    text: '${l10n.scheduleFallowLead} ',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(text: l10n.scheduleFallowBody),
                ],
              ),
            ),
          ],
        ),
        AppCard(
          children: [
            SectionTitle(l10n.scheduleWhyTitle),
            BulletList(items: recommendation.reasons(l10n)),
          ],
        ),
        PlantingFeedbackCard(option: best),
      ],
    );
  }
}

/// Fecha límite para decidir (`.fecha`).
class _DeadlineBanner extends StatelessWidget {
  const _DeadlineBanner({required this.deadline});

  final String deadline;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return MergeSemantics(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: const BoxDecoration(
          color: AppColors.primary,
          borderRadius: AppRadii.card,
        ),
        child: Row(
          spacing: AppSpacing.md,
          children: [
            const ExcludeSemantics(
              child: Icon(
                Icons.calendar_month_outlined,
                size: 32,
                color: AppColors.onPrimary,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.scheduleDecideBefore,
                    style: AppTypography.muted.copyWith(
                      color: AppColors.onPrimary.withValues(alpha: 0.9),
                    ),
                  ),
                  Text(
                    deadline,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.onPrimary,
                    ),
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
