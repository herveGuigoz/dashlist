import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

export 'package:http/http.dart' show Response;

const _pattern = r'<([^>]+)>;\srel="mercure"';

final httpClientProvider = Provider((ref) => Client());

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
