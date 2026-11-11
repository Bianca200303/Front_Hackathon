import 'package:shared_preferences/shared_preferences.dart';
import 'package:siembra_segura/shared/data/campaign_preferences_codec.dart';
import 'package:siembra_segura/shared/domain/campaign_context.dart';
import 'package:siembra_segura/shared/domain/campaign_preferences_store.dart';

/// Guarda las preferencias de campaña en el almacenamiento local del
/// dispositivo (SharedPreferences en Android, NSUserDefaults en iOS).
class SharedPreferencesCampaignPreferencesStore
    implements CampaignPreferencesStore {
  SharedPreferencesCampaignPreferencesStore._(this._preferences);

  /// Clave única bajo la que se guarda todo el contexto, en JSON.
  static const storageKey = 'campaign_preferences';

  final SharedPreferencesWithCache _preferences;

  /// Abre el almacenamiento. Se llama una vez al arrancar la app, antes de
  /// mostrar la primera pantalla.
  static Future<SharedPreferencesCampaignPreferencesStore> open() async {
    final preferences = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: {storageKey},
      ),
    );
    return SharedPreferencesCampaignPreferencesStore._(preferences);
  }

  @override
  CampaignContext? load() {
    final raw = _preferences.getString(storageKey);
    return raw == null ? null : CampaignPreferencesCodec.decode(raw);
  }

  @override
  Future<void> save(CampaignContext context) => _preferences.setString(
    storageKey,
    CampaignPreferencesCodec.encode(context),
  );

  @override
  Future<void> clear() => _preferences.remove(storageKey);
}
