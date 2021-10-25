import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'bootstrap.dart';
import 'src/modules/app/app.dart';
import 'src/services/http/handshake_override.dart';

Future<void> main() async {
  HttpOverrides.runWithHttpOverrides(() {
    bootstrap(() => const ProviderScope(child: Main()));
  }, HandshakeOverride());
}
