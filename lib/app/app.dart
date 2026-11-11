import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:siembra_segura/app/router/app_router.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/theme/app_theme.dart';

/// Raíz de la app: tema, idioma y navegación.
class SiembraSeguraApp extends ConsumerWidget {
  /// Crea la app. Requiere un `ProviderScope` con la configuración y el
  /// almacén de preferencias inyectados (ver `main.dart`).
  const SiembraSeguraApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      locale: const Locale('es'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
