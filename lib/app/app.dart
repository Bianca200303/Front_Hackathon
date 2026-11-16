import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:siembra_segura/app/router/app_router.dart';
import 'package:siembra_segura/core/config/app_config.dart';
import 'package:siembra_segura/core/l10n/app_language_provider.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/l10n/fallback_localizations.dart';
import 'package:siembra_segura/core/theme/app_theme.dart';
import 'package:siembra_segura/core/theme/theme_mode_provider.dart';
import 'package:siembra_segura/core/utils/formatters.dart';
import 'package:siembra_segura/shared/widgets/sample_data_banner.dart';

/// Raíz de la app: tema, idioma y navegación.
class SiembraSeguraApp extends ConsumerWidget {
  /// Crea la app. Requiere un `ProviderScope` con la configuración y el
  /// almacén de preferencias inyectados (ver `main.dart`).
  const SiembraSeguraApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(appLanguageProvider);
    // Fechas y números siguen el idioma; se fija antes de construir las
    // pantallas.
    AppFormatters.useLanguage(language);
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ref.watch(themeModeProvider),
      locale: language.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        ...AppLocalizations.localizationsDelegates,
        ...FallbackLocalizations.delegates,
      ],
      routerConfig: ref.watch(appRouterProvider),
      builder: (context, child) => ref.watch(appConfigProvider).usesMocks
          ? SampleDataBanner(child: child ?? const SizedBox.shrink())
          : child ?? const SizedBox.shrink(),
    );
  }
}
