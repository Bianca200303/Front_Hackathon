import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:siembra_segura/core/error/error_messages.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/theme/app_colors.dart';
import 'package:siembra_segura/core/theme/app_spacing.dart';
import 'package:siembra_segura/features/crop_planning/domain/crop_planning_models.dart';
import 'package:siembra_segura/features/crop_planning/presentation/providers/crop_planning_providers.dart';
import 'package:siembra_segura/shared/widgets/app_button.dart';
import 'package:siembra_segura/shared/widgets/app_card.dart';
import 'package:siembra_segura/shared/widgets/text_blocks.dart';

/// "Cuando siembres, cuéntanos qué fue".
class PlantingFeedbackCard extends ConsumerWidget {
  /// Crea la tarjeta para [option].
  const PlantingFeedbackCard({required this.option, super.key});

  /// Rotación recomendada.
  final RotationOption option;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final status = ref.watch(plantingFeedbackProvider);
    final notifier = ref.read(plantingFeedbackProvider.notifier);
    final submitted = status.value ?? false;
    final sending = status.isLoading;

    return Semantics(
      liveRegion: true,
      container: true,
      child: AppCard(
        children: submitted
            ? [
                SectionTitle(
                  l10n.feedbackThanksTitle,
                  color: AppColors.primary,
                ),
                Text(
                  l10n.feedbackThanksBody,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ]
            : [
                SectionTitle(l10n.feedbackQuestion),
                Row(
                  spacing: AppSpacing.sm,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AppButton(
                        label: l10n.feedbackFollowed(
                          option.crops.first.name.toLowerCase(),
                        ),
                        compact: true,
                        onPressed: sending
                            ? null
                            : () =>
                                  notifier.submit(followedRecommendation: true),
                      ),
                    ),
                    Expanded(
                      child: AppButton(
                        label: l10n.feedbackOther,
                        variant: AppButtonVariant.secondary,
                        onPressed: sending
                            ? null
                            : () => notifier.submit(
                                followedRecommendation: false,
                              ),
                      ),
                    ),
                  ],
                ),
                if (sending) const LinearProgressIndicator(),
                if (status case AsyncError(:final error))
                  Text(
                    userMessageFor(error, l10n),
                    style: const TextStyle(color: AppColors.negative),
                  ),
              ],
      ),
    );
  }
}
