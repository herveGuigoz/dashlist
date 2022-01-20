import 'dart:convert';

import 'package:dashlist/src/modules/app/configuration.dart';
import 'package:dashlist/src/services/http/http.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

export 'package:http/http.dart' show Response;

final httpClientProvider = Provider(
  (ref) => ApiClient(
    client: Client(),
    baseURL: ref.watch(configurationProvider).baseURL,
  ),
  name: 'httpClientProvider',
);

class ApiClient {
  ApiClient({required this.client, required this.baseURL});

  /// Default http header
  static const Header _headers = AcceptJson();

  final Client client;
  final String baseURL;

  Uri uriFrom(String path) => Uri.https(baseURL, path);

  /// Sends an HTTP GET request for the given uri.
  Future<Response> get(String path) async {
    final response = await client.get(
      uriFrom(path),
      headers: _headers.toMap(),
    );

    if (response.statusCode != 200) throw ApiException(response.statusCode);

    return response;
  }

  /// Sends an HTTP POST request for the given uri.
  Future<Response> post(
    String path, {
    required Map<String, Object> body,
  }) async {
    final response = await client.post(
      uriFrom(path),
      headers: Header.merge(const [JsonContentType(), _headers]),
      body: jsonEncode(body),
    );

    if (response.statusCode > 204) throw ApiException(response.statusCode);

    return response;
  }

  /// Sends an HTTP PUT request for the given uri.
  Future<Response> put(String path, {required Map<String, Object> body}) async {
    final response = await client.put(
      uriFrom(path),
      headers: Header.merge(const [JsonContentType(), _headers]),
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) throw ApiException(response.statusCode);

    return response;
  }

  /// Sends an HTTP DELETE request for the given uri.
  Future<void> delete(String path) async {
    final res = await client.delete(uriFrom(path), headers: _headers.toMap());
    if (res.statusCode != 204) throw ApiException(res.statusCode);
  }
}

class ApiException implements Exception {
  ApiException(int statusCode) : statusCode = StatusCode(statusCode);

  final StatusCode statusCode;

  String get reason => statusCode.reason;

  @override
  String toString() => '${statusCode.code}: ${statusCode.reason}';
}
