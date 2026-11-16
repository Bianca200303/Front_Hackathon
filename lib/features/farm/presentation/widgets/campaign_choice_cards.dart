import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/theme/app_spacing.dart';
import 'package:siembra_segura/core/theme/app_typography.dart';
import 'package:siembra_segura/features/farm/domain/farm.dart';
import 'package:siembra_segura/features/farm/presentation/providers/farm_providers.dart';
import 'package:siembra_segura/shared/domain/campaign_catalog.dart';
import 'package:siembra_segura/shared/state/campaign_context_provider.dart';
import 'package:siembra_segura/shared/widgets/selection_controls.dart';
import 'package:siembra_segura/shared/widgets/text_blocks.dart';

/// Campos del llenado manual (`#v-manual` de `semi_app.html`): todo en una
/// pantalla, cada pregunta con sus opciones en chips. Cada cambio se guarda
/// al instante (igual que la conversación con Semi).

/// Un campo: título, ayuda opcional y opciones.
class ChoiceField extends StatelessWidget {
  /// Crea el campo.
  const ChoiceField({
    required this.label,
    required this.child,
    this.help,
    this.optional = false,
    super.key,
  });

  /// Pregunta del campo.
  final String label;

  /// Ayuda debajo de la pregunta.
  final Widget? help;

  /// Agrega "(opcional)" a la pregunta.
  final bool optional;

  /// Opciones.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.sm,
      children: [
        Semantics(
          header: true,
          child: Text.rich(
            TextSpan(
              style: Theme.of(context).textTheme.titleMedium,
              children: [
                TextSpan(text: label),
                if (optional)
                  TextSpan(
                    text: ' ${l10n.optionalLabel}',
                    style: context.text.mutedLabel,
                  ),
              ],
            ),
          ),
        ),
        ?help,
        child,
      ],
    );
  }
}

/// Chips en filas que se acomodan al ancho.
class _Chips extends StatelessWidget {
  const _Chips({required this.children, this.semanticsLabel});

  final List<Widget> children;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticsLabel,
      container: semanticsLabel != null,
      child: Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: children,
      ),
    );
  }
}

/// "¿Qué sembraste la última campaña?": el satélite propone y el agricultor
/// corrige entre las opciones que entrega la parcela.
class LastCropField extends ConsumerWidget {
  /// Crea el campo para [farm].
  const LastCropField({required this.farm, super.key});

  /// Parcela con el cultivo inferido y las opciones.
  final Farm farm;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final selected = ref.watch(selectedLastCropProvider(farm));
    final inferred = farm.inferredLastCrop;
    final notifier = ref.read(campaignContextProvider.notifier);

    return ChoiceField(
      label: l10n.farmLastCropQuestion,
      help: HighlightedText(
        text: l10n.farmLastCropHint(inferred.name),
        highlight: inferred.name,
        style: context.text.muted,
        highlightStyle: context.text.mutedEmphasis,
      ),
      child: _Chips(
        semanticsLabel: l10n.farmLastCropGroupSemantics,
        children: [
          for (final crop in farm.lastCropOptions)
            SelectableChip(
              label: crop.name,
              badge: crop == inferred ? l10n.farmSatelliteBadge : null,
              selected: crop == selected,
              onTap: () => notifier.selectLastCrop(crop.id),
            ),
        ],
      ),
    );
  }
}

/// "¿Qué te importa más esta campaña?": una prioridad del catálogo.
class PriorityField extends ConsumerWidget {
  /// Crea el campo con las prioridades de [catalog].
  const PriorityField({required this.catalog, super.key});

  /// Catálogo con las prioridades disponibles.
  final CampaignCatalog catalog;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final selectedId = ref.watch(
      campaignContextProvider.select((context) => context.priorityId),
    );
    final selected = catalog.priorityOrDefault(selectedId);
    final notifier = ref.read(campaignContextProvider.notifier);

    return ChoiceField(
      label: l10n.farmPriorityQuestion,
      child: _Chips(
        semanticsLabel: l10n.farmPriorityGroupSemantics,
        children: [
          for (final priority in catalog.priorities)
            SelectableChip(
              label: priority.name,
              selected: priority == selected,
              onTap: () => notifier.selectPriority(priority.id),
            ),
        ],
      ),
    );
  }
}

/// "¿Hay algo que no puedas hacer? (opcional)": restricciones del catálogo.
class RestrictionsField extends ConsumerWidget {
  /// Crea el campo con las restricciones de [catalog].
  const RestrictionsField({required this.catalog, super.key});

  /// Catálogo con las restricciones disponibles.
  final CampaignCatalog catalog;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final active = ref.watch(
      campaignContextProvider.select((context) => context.restrictionIds),
    );
    final notifier = ref.read(campaignContextProvider.notifier);

    return ChoiceField(
      label: l10n.farmRestrictionsQuestion,
      optional: true,
      child: _Chips(
        children: [
          for (final restriction in catalog.restrictions)
            SelectableChip(
              label: restriction.name,
              role: SelectionRole.toggle,
              selected: active.contains(restriction.id),
              onTap: () => notifier.toggleRestriction(restriction.id),
            ),
        ],
      ),
    );
  }
}
