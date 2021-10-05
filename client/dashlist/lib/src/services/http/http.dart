import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

import '../../../configuration.dart';
import 'http_enum.dart';

export 'package:http/http.dart' show Response;

const _pattern = r'<([^>]+)>;\srel="mercure"';

final httpClientProvider = Provider(
  (ref) => ApiClient(
    client: Client(),
    baseURL: ref.read(configuration).baseUrl,
  ),
  name: 'httpClientProvider',
);

class ApiClient {
  ApiClient({required this.client, required this.baseURL});

  static Map<String, String> headers = {'Accept': 'application/json'};

  final Client client;
  final String baseURL;

  /// Sends an HTTP GET request for the given uri.
  Future<Response> get(String path) async {
    final res = await client.get(Uri.https(baseURL, path), headers: headers);
    if (res.statusCode != 200) throw ApiException(res.statusCode);
    return res;
  }
}

class ApiException implements Exception {
  ApiException(int statusCode) : statusCode = StatusCode(statusCode);

  final StatusCode statusCode;

  @override
  String toString() => statusCode.reason;
}

extension HeaderExtension on Response {
  String findHeaderByName(String name) {
    if (!headers.containsKey(name)) {
      throw Exception('Link header not found');
    }

    return headers[name]!;
  }

  String get mercureHub {
    final header = findHeaderByName('link');
    final match = RegExp(_pattern).firstMatch(header);

    if (match == null) throw Exception('Hub not found');

    return match.group(1)!;
  }
}
