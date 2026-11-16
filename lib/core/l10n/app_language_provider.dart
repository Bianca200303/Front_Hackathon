import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siembra_segura/core/l10n/app_language.dart';

/// Guarda el idioma elegido a mano. `null` significa "automático" (el del
/// celular).
abstract interface class AppLanguageStore {
  /// Idioma elegido, o `null` si se sigue al celular.
  AppLanguage? load();

  /// Guarda [language]; `null` vuelve a "automático".
  Future<void> save(AppLanguage? language);
}

/// Guarda el idioma en el almacenamiento local del dispositivo.
class SharedPreferencesAppLanguageStore implements AppLanguageStore {
  SharedPreferencesAppLanguageStore._(this._preferences);

  /// Clave bajo la que se guarda el código del idioma.
  static const storageKey = 'app_language';

  final SharedPreferencesWithCache _preferences;

  /// Abre el almacenamiento. Se llama una vez al arrancar la app.
  static Future<SharedPreferencesAppLanguageStore> open() async {
    final preferences = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: {storageKey},
      ),
    );
    return SharedPreferencesAppLanguageStore._(preferences);
  }

  @override
  AppLanguage? load() {
    final raw = _preferences.getString(storageKey);
    return raw == null ? null : AppLanguage.fromCode(raw);
  }

  @override
  Future<void> save(AppLanguage? language) => language == null
      ? _preferences.remove(storageKey)
      : _preferences.setString(storageKey, language.code);
}

/// Guarda el idioma solo mientras la app está abierta (pruebas, o si falla
/// el almacenamiento del dispositivo).
class InMemoryAppLanguageStore implements AppLanguageStore {
  /// Crea el almacén, opcionalmente con un idioma ya elegido.
  InMemoryAppLanguageStore([this._language]);

  AppLanguage? _language;

  @override
  AppLanguage? load() => _language;

  @override
  Future<void> save(AppLanguage? language) async => _language = language;
}

/// Almacén del idioma. `main.dart` inyecta el del dispositivo.
final appLanguageStoreProvider = Provider<AppLanguageStore>(
  (ref) => InMemoryAppLanguageStore(),
);

/// Idiomas configurados en el celular, en orden de preferencia. Se
/// actualiza si el usuario los cambia con la app abierta.
final deviceLocalesProvider =
    NotifierProvider<DeviceLocalesNotifier, List<Locale>>(
      DeviceLocalesNotifier.new,
    );

/// Sigue los idiomas del celular.
class DeviceLocalesNotifier extends Notifier<List<Locale>>
    with WidgetsBindingObserver {
  @override
  List<Locale> build() {
    final binding = WidgetsBinding.instance..addObserver(this);
    ref.onDispose(() => binding.removeObserver(this));
    return binding.platformDispatcher.locales;
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    state = locales ?? const [];
  }
}

/// Idioma elegido a mano en Ajustes; `null` = automático.
final languagePreferenceProvider =
    NotifierProvider<LanguagePreferenceNotifier, AppLanguage?>(
      LanguagePreferenceNotifier.new,
    );

/// Lee y cambia el idioma elegido a mano, guardándolo al instante.
class LanguagePreferenceNotifier extends Notifier<AppLanguage?> {
  @override
  AppLanguage? build() => ref.read(appLanguageStoreProvider).load();

  /// Usa [language] desde ahora; `null` vuelve a seguir al celular.
  Future<void> select(AppLanguage? language) async {
    state = language;
    try {
      await ref.read(appLanguageStoreProvider).save(language);
    } on Object catch (error) {
      // Si no se puede guardar, el cambio vale igual durante esta sesión.
      debugPrint('No se pudo guardar el idioma: $error');
    }
  }
}

/// Idioma en uso: el elegido a mano o, si no, el que corresponde al
/// celular ([AppLanguage.resolve]). Los textos, las fechas, los datos de
/// ejemplo y la voz de Semi lo siguen.
final appLanguageProvider = Provider<AppLanguage>(
  (ref) =>
      ref.watch(languagePreferenceProvider) ??
      AppLanguage.resolve(ref.watch(deviceLocalesProvider)),
);
