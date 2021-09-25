import 'package:flutter_riverpod/flutter_riverpod.dart';

final configurationProvider = Provider((ref) => const Configuration.fromEnv());

class Configuration {
  const Configuration.fromEnv()
      : baseUrl = const String.fromEnvironment('BASE_URL');

  final String baseUrl;
}
