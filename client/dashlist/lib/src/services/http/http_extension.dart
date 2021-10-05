import 'package:http/http.dart';

const _pattern = r'<([^>]+)>;\srel="mercure"';

extension HeaderExtension on Response {
  String findHeaderByName(String name) {
    if (!headers.containsKey(name)) {
      throw Exception('$name header not found');
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
