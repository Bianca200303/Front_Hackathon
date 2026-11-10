import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:siembra_segura/app/placeholder_screen.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/router/app_routes.dart';

class ClimateScreen extends StatelessWidget {
  const ClimateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PlaceholderScreen(
      title: l10n.climateTitle,
      actions: [
        PlaceholderAction(
          l10n.tabWhatToPlant,
          () => context.go(AppRoutes.recommendation),
        ),
      ],
    );
  }
}
