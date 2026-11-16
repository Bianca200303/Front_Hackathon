import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:siembra_segura/core/services/speech/backend_speech_client.dart';

/// Comprueba el contrato de `docs/contracts/voz.md` contra un servidor
/// local de verdad.
void main() {
  late HttpServer server;
  late List<Map<String, Object?>> received;
  late List<String> paths;
  var reply = (HttpResponse response) async {};

  setUp(() async {
    received = [];
    paths = [];
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    server.listen((request) async {
      paths.add(request.uri.path);
      final body = await utf8.decoder.bind(request).join();
      received.add(jsonDecode(body) as Map<String, Object?>);
      await reply(request.response);
      await request.response.close();
    });
  });

  tearDown(() => server.close(force: true));

  BackendSpeechClient client([String basePath = '']) => BackendSpeechClient(
    Uri.parse('http://127.0.0.1:${server.port}$basePath'),
  );

  test('envía el texto en JSON y devuelve el MP3', () async {
    reply = (response) async {
      response.headers.contentType = ContentType('audio', 'mpeg');
      response.add([1, 2, 3]);
    };

    final audio = await client().synthesize('Viene lluvia el jueves');

    expect(audio, [1, 2, 3]);
    expect(paths.single, '/v1/speech');
    expect(received.single, {
      'text': 'Viene lluvia el jueves',
      'language': 'es-PE',
    });
  });

  test('respeta el prefijo de la URL base', () async {
    reply = (response) async {
      response.headers.contentType = ContentType('audio', 'mpeg');
      response.add([1]);
    };

    await client('/api').synthesize('Hola');

    expect(paths.single, '/api/v1/speech');
  });

  test('un error del backend se informa para usar la voz del celular', () {
    reply = (response) async {
      response.statusCode = HttpStatus.serviceUnavailable;
      response.write('motor de voz caído');
    };

    expect(
      client().synthesize('Hola'),
      throwsA(
        isA<HttpException>().having(
          (e) => e.message,
          'message',
          contains('motor de voz caído'),
        ),
      ),
    );
  });

  test('rechaza una respuesta que no es audio', () {
    reply = (response) async {
      response.headers.contentType = ContentType.json;
      response.write('{"ok": true}');
    };

    expect(client().synthesize('Hola'), throwsA(isA<HttpException>()));
  });
}
