import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Guarda si la pantalla va clara, oscura o como el celular.
abstract interface class ThemeModeStore {
  /// Modo guardado, o `null` si nunca se eligió (sigue al celular).
  ThemeMode? load();

  /// Guarda [mode].
  Future<void> save(ThemeMode mode);
}

/// Guarda el modo de pantalla en el almacenamiento local del dispositivo.
class SharedPreferencesThemeModeStore implements ThemeModeStore {
  SharedPreferencesThemeModeStore._(this._preferences);

  /// Clave bajo la que se guarda el nombre del modo.
  static const storageKey = 'theme_mode';

  final SharedPreferencesWithCache _preferences;

  /// Abre el almacenamiento. Se llama una vez al arrancar la app.
  static Future<SharedPreferencesThemeModeStore> open() async {
    final preferences = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: {storageKey},
      ),
    );
    return SharedPreferencesThemeModeStore._(preferences);
  }

  @override
  ThemeMode? load() {
    final raw = _preferences.getString(storageKey);
    return raw == null ? null : ThemeMode.values.asNameMap()[raw];
  }

  @override
  Future<void> save(ThemeMode mode) =>
      _preferences.setString(storageKey, mode.name);
}

/// Guarda el modo solo mientras la app está abierta (pruebas, o si falla el
/// almacenamiento del dispositivo).
class InMemoryThemeModeStore implements ThemeModeStore {
  /// Crea el almacén, opcionalmente con un modo ya elegido.
  InMemoryThemeModeStore([this._mode]);

  ThemeMode? _mode;

  @override
  ThemeMode? load() => _mode;

  @override
  Future<void> save(ThemeMode mode) async => _mode = mode;
}

/// Almacén del modo de pantalla. `main.dart` inyecta el del dispositivo.
final themeModeStoreProvider = Provider<ThemeModeStore>(
  (ref) => InMemoryThemeModeStore(),
);

/// Pantalla clara, oscura o como el celular ([ThemeMode.system], por
/// defecto).
final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

/// Lee y cambia el modo de pantalla, guardándolo al instante.
class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() =>
      ref.read(themeModeStoreProvider).load() ?? ThemeMode.system;

  /// Usa [mode] desde ahora.
  Future<void> select(ThemeMode mode) async {
    state = mode;
    try {
      await ref.read(themeModeStoreProvider).save(mode);
    } on Object catch (error) {
      // Si no se puede guardar, el cambio vale igual durante esta sesión.
      debugPrint('No se pudo guardar el modo de pantalla: $error');
    }
  }
}
