import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';

/// Contenedor de las 4 pestañas principales. Cada pestaña conserva su
/// propio stack de navegación y su estado de scroll.
class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  void _onDestinationSelected(int index) {
    // Volver a tocar la pestaña activa la regresa a su raíz.
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.cloud_outlined),
            selectedIcon: const Icon(Icons.cloud),
            label: l10n.tabClimate,
          ),
          NavigationDestination(
            icon: const Icon(Icons.eco_outlined),
            selectedIcon: const Icon(Icons.eco),
            label: l10n.tabWhatToPlant,
          ),
          NavigationDestination(
            icon: const Icon(Icons.autorenew_rounded),
            label: l10n.tabRotation,
          ),
          // El indicador de avisos no leídos se conecta en la Fase 4
          // (feature `alerts`, decisión B7).
          NavigationDestination(
            icon: const Icon(Icons.notifications_none_rounded),
            selectedIcon: const Icon(Icons.notifications_rounded),
            label: l10n.tabAlerts,
          ),
        ],
      ),
    );
  }
}
