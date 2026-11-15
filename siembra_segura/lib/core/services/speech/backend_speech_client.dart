import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:siembra_segura/core/l10n/app_language.dart';

/// Pide al backend el audio de una frase (contrato propuesto en
/// `docs/contracts/voz.md`, decisión B8).
///
/// La app no guarda ninguna clave: el backend elige el motor de voz
/// (Azure, Google, ElevenLabs, Piper…) y guarda sus credenciales.
class BackendSpeechClient {
  /// Crea el cliente contra la URL base del backend, para frases en
  /// [appLanguage].
  BackendSpeechClient(
    this._baseUrl, {
    this.appLanguage = AppLanguage.spanish,
    HttpClient? httpClient,
  }) : _http = httpClient ?? HttpClient();

  /// Idioma de las frases.
  final AppLanguage appLanguage;

  /// Ruta del endpoint, relativa a `API_BASE_URL`.
  static const path = 'v1/speech';

  /// Idioma y acento que se piden (BCP 47). El quechua va como `qu-PE`: el
  /// backend decide con qué voz leerlo.
  String get language => switch (appLanguage) {
    AppLanguage.spanish => 'es-PE',
    AppLanguage.english => 'en-US',
    AppLanguage.quechua => 'qu-PE',
  };

  static const _timeout = Duration(seconds: 15);

  final Uri _baseUrl;
  final HttpClient _http;

  /// URL completa del endpoint.
  Uri get endpoint => _withTrailingSlash(_baseUrl).resolve(path);

  /// Genera el MP3 de [text].
  Future<Uint8List> synthesize(String text) async {
    final uri = endpoint;
    final request = await _http.postUrl(uri).timeout(_timeout);
    request.headers
      ..contentType = ContentType.json
      ..set(HttpHeaders.acceptHeader, 'audio/mpeg');
    request.write(jsonEncode({'text': text, 'language': language}));
    final response = await request.close().timeout(_timeout);
    final bytes = await response
        .fold<BytesBuilder>(
          BytesBuilder(copy: false),
          (b, chunk) => b..add(chunk),
        )
        .timeout(_timeout);
    if (response.statusCode != HttpStatus.ok) {
      throw HttpException(
        'La voz del backend respondió ${response.statusCode}: '
        '${utf8.decode(bytes.takeBytes(), allowMalformed: true)}',
        uri: uri,
      );
    }
    final type = response.headers.contentType;
    if (type != null && type.primaryType != 'audio') {
      throw HttpException('Se esperaba audio y llegó $type', uri: uri);
    }
    return bytes.takeBytes();
  }

  /// Cierra las conexiones abiertas.
  void close() => _http.close(force: true);

  // Sin barra final, `resolve` reemplazaría el último tramo de la base
  // (`https://x/api` + `v1/speech` → `https://x/v1/speech`).
  static Uri _withTrailingSlash(Uri uri) =>
      uri.path.endsWith('/') ? uri : uri.replace(path: '${uri.path}/');
}
