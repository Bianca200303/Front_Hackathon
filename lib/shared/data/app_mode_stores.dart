import 'package:shared_preferences/shared_preferences.dart';
import 'package:siembra_segura/shared/domain/app_mode.dart';

/// Guarda el modo de uso en el almacenamiento local del dispositivo.
class SharedPreferencesAppModeStore implements AppModeStore {
  SharedPreferencesAppModeStore._(this._preferences);

  /// Clave bajo la que se guarda el nombre del modo.
  static const storageKey = 'app_mode';

  final SharedPreferencesWithCache _preferences;

  /// Abre el almacenamiento. Se llama una vez al arrancar la app.
  static Future<SharedPreferencesAppModeStore> open() async {
    final preferences = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: {storageKey},
      ),
    );
    return SharedPreferencesAppModeStore._(preferences);
  }

  @override
  AppMode? load() {
    final raw = _preferences.getString(storageKey);
    // Un valor desconocido (versión futura) se trata como "sin elegir".
    return raw == null ? null : AppMode.values.asNameMap()[raw];
  }

  @override
  Future<void> save(AppMode mode) =>
      _preferences.setString(storageKey, mode.name);

  @override
  Future<void> clear() => _preferences.remove(storageKey);
}

/// Guarda el modo solo mientras la app está abierta. Se usa en pruebas y
/// si el almacenamiento del dispositivo falla.
class InMemoryAppModeStore implements AppModeStore {
  /// Crea el almacén, opcionalmente con un modo ya elegido.
  InMemoryAppModeStore([this._mode]);

  AppMode? _mode;

  @override
  AppMode? load() => _mode;

  @override
  Future<void> save(AppMode mode) async => _mode = mode;

  @override
  Future<void> clear() async => _mode = null;
}
