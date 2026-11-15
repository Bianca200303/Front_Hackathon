/// Cómo prefiere usar la app la persona.
///
/// Los dos modos muestran los mismos datos y permiten hacer lo mismo; solo
/// cambia la presentación.
enum AppMode {
  /// Semi acompaña cada pantalla: explica, guía y habla.
  assisted,

  /// Pantallas directas, sin guía, para quien ya sabe lo que busca.
  manual,
}

/// Dónde se recuerda el modo elegido.
abstract interface class AppModeStore {
  /// Modo guardado, o `null` si nunca se eligió. Es síncrono para decidir
  /// la presentación desde el primer cuadro.
  AppMode? load();

  /// Guarda el modo.
  Future<void> save(AppMode mode);
}
