import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/theme/app_breakpoints.dart';
import 'package:siembra_segura/features/alerts/presentation/providers/alerts_providers.dart';
import 'package:siembra_segura/shared/widgets/screen_layout.dart';
import 'package:siembra_segura/shared/widgets/semi/semi_help.dart';

/// Contenedor de las 4 pestañas principales. Cada pestaña conserva su
/// propio stack de navegación y su estado de scroll.
///
/// La navegación se adapta al ancho de la ventana (ver [AppBreakpoints]):
/// barra inferior en teléfonos en vertical y riel lateral en tablets y en
/// teléfonos en horizontal, donde el alto es escaso.
class AppShell extends ConsumerWidget {
  /// Crea el contenedor para el [navigationShell] de go_router.
  const AppShell({required this.navigationShell, super.key});

  /// Estado de las pestañas que entrega `StatefulShellRoute`.
  final StatefulNavigationShell navigationShell;

  void _onDestinationSelected(int index) {
    // Volver a tocar la pestaña activa la regresa a su raíz.
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final hasUnreadAlerts = ref.watch(hasUnreadAlertsProvider);
    final destinations = _destinations(l10n, hasUnreadAlerts: hasUnreadAlerts);
    final windowWidth = MediaQuery.sizeOf(context).width;
    final help = SemiHelpButton(
      section: HelpSection.values[navigationShell.currentIndex],
    );

    if (!AppBreakpoints.usesNavigationRail(windowWidth)) {
      return Scaffold(
        body: navigationShell,
        floatingActionButton: help,
        bottomNavigationBar: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _onDestinationSelected,
          destinations: [
            for (final destination in destinations)
              NavigationDestination(
                icon: destination.icon,
                selectedIcon: destination.selectedIcon,
                label: destination.label,
                tooltip: destination.tooltip,
              ),
          ],
        ),
      );
    }

    return Scaffold(
      floatingActionButton: help,
      body: Row(
        children: [
          SafeArea(
            right: false,
            child: NavigationRail(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: _onDestinationSelected,
              labelType: NavigationRailLabelType.all,
              groupAlignment: -1,
              leading: windowWidth >= AppBreakpoints.expanded
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: AppLogo(),
                    )
                  : null,
              destinations: [
                for (final destination in destinations)
                  NavigationRailDestination(
                    icon: switch (destination.tooltip) {
                      final tooltip? => Tooltip(
                        message: tooltip,
                        child: destination.icon,
                      ),
                      null => destination.icon,
                    },
                    selectedIcon: destination.selectedIcon,
                    label: Text(destination.label),
                  ),
              ],
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(child: navigationShell),
        ],
      ),
    );
  }

  List<_Destination> _destinations(
    AppLocalizations l10n, {
    required bool hasUnreadAlerts,
  }) {
    Widget alertsIcon(IconData icon) =>
        Badge(isLabelVisible: hasUnreadAlerts, smallSize: 9, child: Icon(icon));

    return [
      _Destination(
        icon: const Icon(Icons.cloud_outlined),
        selectedIcon: const Icon(Icons.cloud),
        label: l10n.tabClimate,
      ),
      _Destination(
        icon: const Icon(Icons.eco_outlined),
        selectedIcon: const Icon(Icons.eco),
        label: l10n.tabWhatToPlant,
      ),
      _Destination(
        icon: const Icon(Icons.autorenew_rounded),
        selectedIcon: const Icon(Icons.autorenew_rounded),
        label: l10n.tabRotation,
      ),
      _Destination(
        icon: alertsIcon(Icons.notifications_none_rounded),
        selectedIcon: alertsIcon(Icons.notifications_rounded),
        label: l10n.tabAlerts,
        tooltip: hasUnreadAlerts ? l10n.tabAlertsUnreadSemantics : null,
      ),
    ];
  }
}

/// Datos de una pestaña, comunes a la barra inferior y al riel lateral.
class _Destination {
  const _Destination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    this.tooltip,
  });

  final Widget icon;
  final Widget selectedIcon;
  final String label;
  final String? tooltip;
}
