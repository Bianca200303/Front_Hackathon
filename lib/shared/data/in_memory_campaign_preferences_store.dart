import 'package:siembra_segura/shared/domain/campaign_context.dart';
import 'package:siembra_segura/shared/domain/campaign_preferences_store.dart';

/// Guarda las preferencias solo mientras la app está abierta.
///
/// Se usa en tests y como respaldo si el almacenamiento del dispositivo no
/// se puede abrir (la app funciona igual, pero no recuerda la
/// configuración).
class InMemoryCampaignPreferencesStore implements CampaignPreferencesStore {
  /// Crea el almacén, opcionalmente con preferencias ya guardadas.
  InMemoryCampaignPreferencesStore([this._saved]);

  CampaignContext? _saved;

  @override
  CampaignContext? load() => _saved;

  @override
  Future<void> save(CampaignContext context) async {
    _saved = context.preferencesOnly;
  }

  @override
  Future<void> clear() async {
    _saved = null;
  }
}
