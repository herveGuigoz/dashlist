import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

import '../../../configuration.dart';
import 'http_enum.dart';

export 'package:http/http.dart' show Response;

final httpClientProvider = Provider(
  (ref) => ApiClient(
    client: Client(),
    baseURL: ref.read(configuration).baseUrl,
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
    final res = await client.get(uriFrom(path), headers: _headers.toMap());
    if (res.statusCode != 200) throw ApiException(res.statusCode);
    return res;
  }

  /// Sends an HTTP POST request for the given uri.
  Future<void> post(String path, {required Map<String, Object> body}) async {
    final res = await client.post(
      uriFrom(path),
      headers: Header.merge(const [JsonContentType(), _headers]),
      body: jsonEncode(body),
    );

    if (res.statusCode > 204) throw ApiException(res.statusCode);
  }

  /// Sends an HTTP PUT request for the given uri.
  Future<void> put(String path, {required Map<String, Object> body}) async {
    final res = await client.put(
      uriFrom(path),
      headers: Header.merge(const [JsonContentType(), _headers]),
      body: jsonEncode(body),
    );

    if (res.statusCode != 200) throw ApiException(res.statusCode);
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
