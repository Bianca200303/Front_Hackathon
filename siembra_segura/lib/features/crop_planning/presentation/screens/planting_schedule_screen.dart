import 'package:flutter/material.dart';
import 'package:siembra_segura/app/placeholder_screen.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';

class PlantingScheduleScreen extends StatelessWidget {
  const PlantingScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceholderScreen(
      title: AppLocalizations.of(context).plantingScheduleTitle,
      showAppBar: true,
    );
  }
}
