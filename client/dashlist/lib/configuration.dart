// ignore_for_file: do_not_use_environment

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// App configuration provider
final configuration = Provider((ref) => const Configuration.fromEnv());

/// App configuration
class Configuration {
  /// App configuration from environment
  const Configuration.fromEnv({
    this.baseUrl = const String.fromEnvironment('BASE_URL'),
  });

  /// server endpoint
  final String baseUrl;
}
