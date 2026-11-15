import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:siembra_segura/shared/data/app_mode_stores.dart';
import 'package:siembra_segura/shared/domain/app_mode.dart';

/// Almacén del modo de uso. `main.dart` inyecta el del dispositivo; por
/// defecto (pruebas) vive en memoria.
final appModeStoreProvider = Provider<AppModeStore>(
  (ref) => InMemoryAppModeStore(),
);

/// Modo de uso vigente. Si nunca se eligió, empieza en [AppMode.assisted]
/// y la bienvenida (`AppRoutes.welcome`) pregunta cómo se quiere usar.
final appModeProvider = NotifierProvider<AppModeNotifier, AppMode>(
  AppModeNotifier.new,
);

/// Lee y cambia el modo de uso, guardándolo al instante.
class AppModeNotifier extends Notifier<AppMode> {
  @override
  AppMode build() {
    return ref.read(appModeStoreProvider).load() ?? AppMode.assisted;
  }

  /// Cambia al modo [mode] y lo recuerda para la próxima vez.
  Future<void> select(AppMode mode) async {
    state = mode;
    try {
      await ref.read(appModeStoreProvider).save(mode);
    } on Object catch (error) {
      // Si no se puede guardar, el cambio vale igual durante esta sesión.
      debugPrint('No se pudo guardar el modo de uso: $error');
    }
  }
}
