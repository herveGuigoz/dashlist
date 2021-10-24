import 'dart:io';

String _getPathForTests(String relativePath) {
  final dir = Directory.current;
  final path = dir.path.endsWith('/test') ? dir.path : '${dir.path}/test';

  return '$path/$relativePath';
}

Future<String> loadJson(String relativePath) async {
  final path = _getPathForTests(relativePath);
  return File(path).readAsString();
}
