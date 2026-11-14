import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:siembra_segura/core/error/app_exception.dart';
import 'package:siembra_segura/core/network/api_client.dart';

/// [ApiClient] sobre `package:http` que traduce todo error a
/// [AppException].
class HttpApiClient implements ApiClient {
  /// Crea el cliente sobre [endpoints]; [client] se inyecta en los tests.
  HttpApiClient({
    required ApiEndpoints endpoints,
    required http.Client client,
    this.timeout = const Duration(seconds: 20),
  }) : _endpoints = endpoints,
       _client = client;

  final ApiEndpoints _endpoints;
  final http.Client _client;

  /// Espera máxima por respuesta.
  final Duration timeout;

  static const _acceptJson = {'Accept': 'application/json'};

  @override
  Future<Object?> get(String path, {Map<String, String>? query}) => _send(
    () => _client.get(_endpoints.resolve(path, query), headers: _acceptJson),
  );

  @override
  Future<Object?> post(String path, {Object? body}) => _send(
    () => _client.post(
      _endpoints.resolve(path),
      headers: {..._acceptJson, 'Content-Type': 'application/json'},
      body: jsonEncode(body),
    ),
  );

  Future<Object?> _send(Future<http.Response> Function() request) async {
    final http.Response response;
    try {
      response = await request().timeout(timeout);
    } on TimeoutException catch (error) {
      throw RequestTimeoutException(error);
    } on http.ClientException catch (error) {
      throw NetworkException(error);
    }

    if (response.statusCode >= 400) {
      throw AppException.fromStatusCode(response.statusCode, response.body);
    }
    if (response.bodyBytes.isEmpty) return null;
    try {
      // `response.body` decodifica en latin1 cuando el servidor no declara
      // charset (FastAPI no lo hace), lo que rompe las tildes.
      return jsonDecode(utf8.decode(response.bodyBytes));
    } on FormatException catch (error) {
      throw UnexpectedException(error);
    }
  }
}

/// Cliente HTTP del backend. Falla si no hay `API_BASE_URL` configurada.
final apiClientProvider = Provider<ApiClient>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return HttpApiClient(
    endpoints: ref.watch(apiEndpointsProvider),
    client: client,
  );
});
