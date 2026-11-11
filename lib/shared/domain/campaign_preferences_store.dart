import 'package:siembra_segura/shared/domain/campaign_context.dart';

/// Dónde se guardan las preferencias de campaña del agricultor.
///
/// Hoy se guardan en el dispositivo
/// (`SharedPreferencesCampaignPreferencesStore`). Si el backend también las
/// guarda en el perfil (decisión B5), se agrega otra implementación sin
/// cambiar a quienes la usan.
abstract interface class CampaignPreferencesStore {
  /// Preferencias guardadas, o `null` si el agricultor nunca configuró su
  /// campaña. Es síncrono para poder decidir la pantalla inicial al
  /// arrancar.
  CampaignContext? load();

  /// Guarda las preferencias (sin el escenario explorado).
  Future<void> save(CampaignContext context);

  /// Borra las preferencias guardadas.
  Future<void> clear();
}
