/// Lectura tipada de un objeto JSON ya decodificado.
///
/// Cualquier campo ausente o de otro tipo lanza [FormatException], para que
/// las fuentes remotas traduzcan un único tipo de error de formato.
extension type const JsonObject._(Map<String, Object?> _fields) {
  /// Envuelve [value], que debe ser un objeto JSON.
  factory JsonObject(Object? value) => switch (value) {
    final Map<String, Object?> fields => JsonObject._(fields),
    _ => throw FormatException('Se esperaba un objeto JSON.', value),
  };

  /// Texto del campo [key].
  String string(String key) => _read<String>(key);

  /// Número del campo [key].
  double number(String key) => _read<num>(key).toDouble();

  /// Fecha ISO (`YYYY-MM-DD`) del campo [key], en hora local.
  DateTime date(String key) => DateTime.parse(string(key));

  /// Entero del campo [key].
  int integer(String key) => _read<num>(key).round();

  /// Booleano del campo [key].
  bool boolean(String key) => _read<bool>(key);

  /// Lista de textos del campo [key].
  List<String> strings(String key) => _read<List<Object?>>(key)
      .map(
        (value) => switch (value) {
          final String text => text,
          final other => throw FormatException(
            'Texto inválido en "$key".',
            other,
          ),
        },
      )
      .toList();

  /// Lista de fechas ISO (`YYYY-MM-DD`) del campo [key], en hora local.
  List<DateTime> dates(String key) => [
    for (final raw in strings(key)) DateTime.parse(raw),
  ];

  /// Claves presentes, para objetos usados como diccionario.
  Iterable<String> get keys => _fields.keys;

  /// Objeto anidado del campo [key].
  JsonObject object(String key) => JsonObject(_fields[key]);

  /// Objeto anidado del campo [key], o `null` si el campo es `null`.
  ///
  /// Para los campos que el backend deja vacíos a propósito (p. ej., una
  /// medición que todavía no tiene).
  JsonObject? objectOrNull(String key) =>
      _fields[key] == null ? null : object(key);

  /// Lista de objetos del campo [key].
  List<JsonObject> objects(String key) =>
      _read<List<Object?>>(key).map(JsonObject.new).toList();

  /// Valor de una escala cerrada: [key] debe ser una de las claves de
  /// [values].
  T oneOf<T>(String key, Map<String, T> values) {
    final raw = string(key);
    return values[raw] ??
        (throw FormatException('Valor desconocido en "$key".', raw));
  }

  T _read<T>(String key) => switch (_fields[key]) {
    final T value => value,
    final other => throw FormatException('Campo "$key" inválido.', other),
  };
}
