// ignore_for_file: do_not_use_environment

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// App configuration provider
final configuration = Provider((ref) => Configuration.fromEnv());

/// App configuration
class Configuration {
  /// App configuration from environment
  Configuration.fromEnv({
    this.baseUrl = const String.fromEnvironment('BASE_URL'),
  }) : mercureHub = 'https://$baseUrl/.well-known/mercure';

  /// Server endpoint
  final String baseUrl;

  /// Mercure subscriber url.
  final String mercureHub;
}
