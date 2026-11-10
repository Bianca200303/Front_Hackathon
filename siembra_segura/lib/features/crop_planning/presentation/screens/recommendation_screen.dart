import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:siembra_segura/app/placeholder_screen.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/router/app_routes.dart';

class RecommendationScreen extends StatelessWidget {
  const RecommendationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PlaceholderScreen(
      title: l10n.recommendationTitle,
      actions: [
        PlaceholderAction(
          l10n.actionWhenToPlant,
          () => context.go(AppRoutes.plantingSchedule),
        ),
        PlaceholderAction(
          l10n.actionCompareOptions,
          () => context.go(AppRoutes.rotation),
        ),
        PlaceholderAction(l10n.actionChange, () => context.go(AppRoutes.farm)),
      ],
    );
  }
}
