import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:siembra_segura/app/app.dart';
import 'package:siembra_segura/core/config/app_config.dart';
import 'package:siembra_segura/core/network/retry_policy.dart';
import 'package:siembra_segura/shared/data/in_memory_campaign_preferences_store.dart';
import 'package:siembra_segura/shared/data/shared_preferences_campaign_preferences_store.dart';
import 'package:siembra_segura/shared/domain/campaign_preferences_store.dart';
import 'package:siembra_segura/shared/state/campaign_context_provider.dart';

/// Punto de entrada: valida la configuración, prepara los formatos de
/// fecha y abre el almacenamiento local antes de mostrar la primera
/// pantalla.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Falla al arrancar si la configuración del entorno es inválida.
  final config = AppConfig.fromEnvironment();
  await initializeDateFormatting('es');
  final preferencesStore = await _openPreferencesStore();

  runApp(
    ProviderScope(
      retry: retryTransientErrors,
      overrides: [
        appConfigProvider.overrideWithValue(config),
        campaignPreferencesStoreProvider.overrideWithValue(preferencesStore),
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
