import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:siembra_segura/app/app.dart';
import 'package:siembra_segura/core/config/app_config.dart';
import 'package:siembra_segura/core/l10n/app_language_provider.dart';
import 'package:siembra_segura/core/network/retry_policy.dart';
import 'package:siembra_segura/core/theme/theme_mode_provider.dart';
import 'package:siembra_segura/shared/data/app_mode_stores.dart';
import 'package:siembra_segura/shared/data/in_memory_campaign_preferences_store.dart';
import 'package:siembra_segura/shared/data/shared_preferences_campaign_preferences_store.dart';
import 'package:siembra_segura/shared/domain/app_mode.dart';
import 'package:siembra_segura/shared/domain/campaign_preferences_store.dart';
import 'package:siembra_segura/shared/state/app_mode_provider.dart';
import 'package:siembra_segura/shared/state/campaign_context_provider.dart';

/// Punto de entrada: valida la configuración, prepara los formatos de
/// fecha y abre el almacenamiento local antes de mostrar la primera
/// pantalla.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Falla al arrancar si la configuración del entorno es inválida.
  final config = AppConfig.fromEnvironment();
  await initializeDateFormatting();
  final preferencesStore = await _openPreferencesStore();
  final appModeStore = await _openAppModeStore();
  final languageStore = await _openLanguageStore();
  final themeModeStore = await _openThemeModeStore();

  runApp(
    ProviderScope(
      retry: retryTransientErrors,
      overrides: [
        appConfigProvider.overrideWithValue(config),
        campaignPreferencesStoreProvider.overrideWithValue(preferencesStore),
        appModeStoreProvider.overrideWithValue(appModeStore),
        appLanguageStoreProvider.overrideWithValue(languageStore),
        themeModeStoreProvider.overrideWithValue(themeModeStore),
      ],
      child: const SiembraSeguraApp(),
    ),
  );
}

/// Si el almacenamiento del dispositivo falla, la app arranca igual: solo
/// deja de recordar la configuración entre sesiones.
Future<CampaignPreferencesStore> _openPreferencesStore() async {
  try {
    return await SharedPreferencesCampaignPreferencesStore.open();
  } on Object catch (error) {
    debugPrint('Almacenamiento local no disponible: $error');
    return InMemoryCampaignPreferencesStore();
  }
}

/// Igual que las preferencias: si falla, el modo se recuerda solo en esta
/// sesión.
Future<AppModeStore> _openAppModeStore() async {
  try {
    return await SharedPreferencesAppModeStore.open();
  } on Object catch (error) {
    debugPrint('Almacenamiento local no disponible: $error');
    return InMemoryAppModeStore();
  }
}

/// Igual que el modo: si falla, el idioma elegido se recuerda solo en esta
/// sesión (y mientras tanto se sigue al celular).
Future<AppLanguageStore> _openLanguageStore() async {
  try {
    return await SharedPreferencesAppLanguageStore.open();
  } on Object catch (error) {
    debugPrint('Almacenamiento local no disponible: $error');
    return InMemoryAppLanguageStore();
  }
}

/// Igual que el idioma: si falla, la pantalla sigue al celular.
Future<ThemeModeStore> _openThemeModeStore() async {
  try {
    return await SharedPreferencesThemeModeStore.open();
  } on Object catch (error) {
    debugPrint('Almacenamiento local no disponible: $error');
    return InMemoryThemeModeStore();
  }
}
