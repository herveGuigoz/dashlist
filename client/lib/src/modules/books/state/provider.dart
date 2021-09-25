import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

const _booksURL = 'https://localhost/books';

final _kHeaders = {'Accept': 'Application/json'};

final httpClientProvider = Provider(
  (ref) => Client(),
);

final booksProvider = FutureProvider<Response>((ref) async {
  final client = ref.read(httpClientProvider);
  return client.get(Uri.parse(_booksURL), headers: _kHeaders);
});

// todo play with response.headers['etag']

final hubProvider = FutureProvider((ref) async {
  final response = await ref.watch(booksProvider.future);
  final linkHeader = HubResolver.findLinkHeader(response);
  return HubResolver.parseMercureHub(linkHeader);
});

class HubResolver {
  static const pattern = r'<([^>]+)>;\srel="mercure"';

  static String findLinkHeader(Response response) {
    if (!response.headers.containsKey('link')) {
      throw Exception('Link header not found');
    }

    return response.headers['link']!;
  }

  static String parseMercureHub(String header) {
    final match = RegExp(pattern).firstMatch(header);

    if (match == null) throw Exception('Hub not found');

    return match.group(1)!;
  }
}
