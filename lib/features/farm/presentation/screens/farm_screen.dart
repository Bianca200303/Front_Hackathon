import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/router/app_routes.dart';
import 'package:siembra_segura/core/theme/app_typography.dart';
import 'package:siembra_segura/core/utils/async_value_combine.dart';
import 'package:siembra_segura/features/farm/domain/farm.dart';
import 'package:siembra_segura/features/farm/presentation/providers/farm_providers.dart';
import 'package:siembra_segura/features/farm/presentation/widgets/campaign_choice_cards.dart';
import 'package:siembra_segura/features/farm/presentation/widgets/campaign_inputs_card.dart';
import 'package:siembra_segura/features/farm/presentation/widgets/parcel_map_card.dart';
import 'package:siembra_segura/features/farm/presentation/widgets/soil_texture_card.dart';
import 'package:siembra_segura/shared/domain/campaign_catalog.dart';
import 'package:siembra_segura/shared/state/campaign_catalog_provider.dart';
import 'package:siembra_segura/shared/state/campaign_context_provider.dart';
import 'package:siembra_segura/shared/widgets/app_button.dart';
import 'package:siembra_segura/shared/widgets/async_value_view.dart';
import 'package:siembra_segura/shared/widgets/responsive_columns.dart';
import 'package:siembra_segura/shared/widgets/screen_layout.dart';
import 'package:siembra_segura/shared/widgets/semi/semi_guide.dart';

/// Pantalla "Mi parcela": recoge lo que condiciona la recomendación.
///
/// Se usa de dos formas:
/// - **Primera vez** (pantalla inicial, sin historial): el botón
///   "Empezar" lleva a Clima.
/// - **Desde las pestañas** (abierta con `push`): muestra "Volver" y el
///   botón "Listo" regresa a donde estaba el agricultor.
///
/// Cada elección se guarda al instante; no hay botón "Guardar".
class FarmScreen extends ConsumerWidget {
  /// Crea la pantalla.
  const FarmScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final farm = ref.watch(farmProvider);
    final content = combineAsync(
      farm,
      ref.watch(campaignCatalogProvider),
      (farm, catalog) => (farm: farm, catalog: catalog),
    );
    final narration = switch (farm) {
      AsyncData(:final value) => l10n.farmNarration(
        value.farmerName,
        ref.watch(selectedLastCropProvider(value)).name.toLowerCase(),
      ),
      _ => null,
    };
    // Se mira la propia página y no `context.canPop()`: una hoja abierta
    // encima (la bienvenida de Semi) también permitiría "volver".
    final openedFromTabs = !(ModalRoute.of(context)?.isFirst ?? true);

    return ScreenLayout(
      guide: SemiGuide(message: l10n.semiFarmGuide),
      wide: true,
      header: openedFromTabs
          ? ScreenHeader.back(
              fallbackLocation: AppRoutes.climate,
              listenText: narration,
            )
          : ScreenHeader.brand(listenText: narration),
      footer: AppButton(
        label: openedFromTabs ? l10n.actionDone : l10n.actionSeePlan,
        onPressed: !content.hasValue
            ? null
            : () => openedFromTabs
                  ? context.pop()
                  : context.go(AppRoutes.climate),
      ),
      body: AsyncValueView(
        value: content,
        onRetry: () => ref
          ..invalidate(farmProvider)
          ..invalidate(campaignCatalogProvider),
        data: (content) =>
            _FarmContent(farm: content.farm, catalog: content.catalog),
      ),
    );
  }
}

class _FarmContent extends StatelessWidget {
  const _FarmContent({required this.farm, required this.catalog});

  final Farm farm;
  final CampaignCatalog catalog;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ScreenContent(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.farmGreeting(farm.farmerName), style: context.text.muted),
            Semantics(
              header: true,
              child: Text(
                l10n.farmTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ],
        ),
        // En tablet, dos columnas; en teléfono, una pregunta debajo de otra.
        // El mapa, las hectáreas, la fecha y la tierra son lo que el backend
        // necesita para calcular (decisiones 29, 32 y 35).
        ResponsiveColumns(
          children: [
            ParcelMapCard(farm: farm),
            LastCropField(farm: farm),
          ],
        ),
        ResponsiveColumns(
          children: [
            CampaignInputsCard(farm: farm),
            PriorityField(catalog: catalog),
          ],
        ),
        SoilTextureCard(catalog: catalog),
        RestrictionsField(catalog: catalog),
        const _ResetPreferencesButton(),
      ],
    );
  }
}

/// "Volver a los valores sugeridos", con opción de deshacer.
class _ResetPreferencesButton extends ConsumerWidget {
  const _ResetPreferencesButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final hasPreferences = ref.watch(
      campaignContextProvider.select((context) => !context.hasNoPreferences),
    );

    void reset() {
      final notifier = ref.read(campaignContextProvider.notifier);
      final previous = notifier.reset();
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(l10n.farmResetDone),
            action: SnackBarAction(
              label: l10n.actionUndo,
              onPressed: () => notifier.restore(previous),
            ),
          ),
        );
    }

    return Center(
      child: TextButton.icon(
        icon: const Icon(Icons.restart_alt_rounded),
        label: Text(l10n.farmResetAction),
        onPressed: hasPreferences ? reset : null,
      ),
    );
  }
}
