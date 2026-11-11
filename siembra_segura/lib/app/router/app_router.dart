import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:siembra_segura/app/router/app_shell.dart';
import 'package:siembra_segura/core/router/app_routes.dart';
import 'package:siembra_segura/core/services/speech/speech_service.dart';
import 'package:siembra_segura/features/alerts/presentation/screens/alert_message_screen.dart';
import 'package:siembra_segura/features/alerts/presentation/screens/alerts_screen.dart';
import 'package:siembra_segura/features/climate/presentation/screens/climate_screen.dart';
import 'package:siembra_segura/features/crop_planning/presentation/screens/planting_schedule_screen.dart';
import 'package:siembra_segura/features/crop_planning/presentation/screens/recommendation_screen.dart';
import 'package:siembra_segura/features/crop_planning/presentation/screens/rotation_screen.dart';
import 'package:siembra_segura/features/farm/presentation/screens/farm_screen.dart';
import 'package:siembra_segura/shared/state/campaign_context_provider.dart';

/// Composición de la navegación. Es el único lugar que conoce las
/// pantallas de todos los features.
///
/// "Mi parcela" ([AppRoutes.farm]) está fuera de las pestañas: es la
/// pantalla inicial la primera vez y, después, se abre encima de cualquier
/// pestaña con `push` (botón de ajustes de cada cabecera).
GoRouter createAppRouter({String initialLocation = AppRoutes.farm}) {
  final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: AppRoutes.farm,
        builder: (context, state) => const FarmScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.climate,
                builder: (context, state) => const ClimateScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.recommendation,
                builder: (context, state) => const RecommendationScreen(),
                routes: [
                  // Se muestra encima del shell, sin barra de pestañas.
                  GoRoute(
                    path: _childPath(
                      AppRoutes.plantingSchedule,
                      AppRoutes.recommendation,
                    ),
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) => const PlantingScheduleScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.rotation,
                builder: (context, state) => const RotationScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.alerts,
                builder: (context, state) => const AlertsScreen(),
                routes: [
                  GoRoute(
                    path: _childPath(
                      AppRoutes.alertDetailPattern,
                      AppRoutes.alerts,
                    ),
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) => AlertMessageScreen(
                      alertId: state.pathParameters[Params.alertId]!,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

/// go_router exige rutas hijas relativas; se derivan de [AppRoutes] para
/// mantener una única fuente de verdad.
String _childPath(String fullPath, String parentPath) {
  assert(fullPath.startsWith('$parentPath/'));
  return fullPath.substring(parentPath.length + 1);
}

/// Router de la app.
///
/// Si el agricultor ya configuró su campaña en una sesión anterior, abre
/// directamente en Clima; si no, en "Mi parcela".
final appRouterProvider = Provider<GoRouter>((ref) {
  final hasSavedPreferences =
      ref.read(campaignPreferencesStoreProvider).load() != null;
  final router = createAppRouter(
    initialLocation: hasSavedPreferences ? AppRoutes.climate : AppRoutes.farm,
  );
  final speech = ref.read(speechServiceProvider);

  // Como en la referencia: al cambiar de pantalla se corta la lectura.
  void stopSpeech() => speech.stop();
  router.routerDelegate.addListener(stopSpeech);

  ref.onDispose(() {
    router.routerDelegate.removeListener(stopSpeech);
    router.dispose();
  });
  return router;
});
