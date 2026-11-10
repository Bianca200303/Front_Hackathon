import 'package:flutter/material.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/theme/app_spacing.dart';
import 'package:siembra_segura/shared/widgets/constrained_content.dart';

/// TEMPORAL (Fase 3): pantalla esqueleto para validar navegación.
/// Se elimina cuando cada feature implemente su pantalla real (Fase 4).
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({
    required this.title,
    this.actions = const [],
    this.showAppBar = false,
    super.key,
  });

  final String title;
  final List<PlaceholderAction> actions;
  final bool showAppBar;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: showAppBar ? AppBar() : null,
      body: SafeArea(
        child: ConstrainedContent(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.screenGutter),
            children: [
              Text(title, style: theme.textTheme.headlineMedium),
              const SizedBox(height: AppSpacing.sm),
              Text(AppLocalizations.of(context).placeholderUnderConstruction),
              for (final action in actions) ...[
                const SizedBox(height: AppSpacing.md),
                FilledButton(
                  onPressed: action.onPressed,
                  child: Text(action.label),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class PlaceholderAction {
  const PlaceholderAction(this.label, this.onPressed);

  final String label;
  final VoidCallback onPressed;
}
