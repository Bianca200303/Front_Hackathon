import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:siembra_segura/core/error/app_exception.dart';
import 'package:siembra_segura/core/network/api_client.dart';
import 'package:siembra_segura/core/network/http_api_client.dart';

void main() {
  final endpoints = ApiEndpoints(Uri.parse('https://api.example.com/'));

  HttpApiClient clientWith(
    MockClientHandler handler, {
    Duration timeout = const Duration(seconds: 1),
  }) => HttpApiClient(
    endpoints: endpoints,
    client: MockClient(handler),
    timeout: timeout,
  );

  test('resuelve la ruta con sus parámetros y decodifica UTF-8', () async {
    late Uri requested;
    final client = clientWith((request) async {
      requested = request.url;
      return http.Response.bytes(utf8.encode('{"day":"miércoles"}'), 200);
    });

    final body = await client.get('api/v1/x', query: {'lat': '-5.19'});

    expect(requested, Uri.parse('https://api.example.com/api/v1/x?lat=-5.19'));
    expect(body, {'day': 'miércoles'});
  });

  test('traduce los errores HTTP a AppException', () async {
    final client = clientWith((_) async => http.Response('{}', 503));

    await expectLater(client.get('x'), throwsA(isA<ServerException>()));
  });

  test('sin conexión lanza NetworkException', () async {
    final client = clientWith(
      (_) async => throw http.ClientException('sin señal'),
    );

    await expectLater(client.get('x'), throwsA(isA<NetworkException>()));
  });

  test('si el servidor no responde a tiempo lanza '
      'RequestTimeoutException', () async {
    final client = clientWith(
      (_) => Completer<http.Response>().future,
      timeout: const Duration(milliseconds: 1),
    );

    await expectLater(client.get('x'), throwsA(isA<RequestTimeoutException>()));
  });

  test('una respuesta que no es JSON lanza UnexpectedException', () async {
    final client = clientWith((_) async => http.Response('<html>', 200));

    await expectLater(client.get('x'), throwsA(isA<UnexpectedException>()));
  });
}
