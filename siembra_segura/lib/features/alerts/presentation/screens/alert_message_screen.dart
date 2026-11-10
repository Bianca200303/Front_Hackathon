import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:siembra_segura/app/placeholder_screen.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/router/app_routes.dart';

class AlertMessageScreen extends StatelessWidget {
  const AlertMessageScreen({required this.alertId, super.key});

  final String alertId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PlaceholderScreen(
      title: l10n.alertMessageTitle,
      showAppBar: true,
      actions: [
        PlaceholderAction(
          l10n.actionSeeMyRecommendation,
          () => context.go(AppRoutes.recommendation),
        ),
        PlaceholderAction(
          l10n.actionWhenToPlant,
          () => context.go(AppRoutes.plantingSchedule),
        ),
      ],
    );
  }
}
