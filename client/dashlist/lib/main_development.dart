import 'dart:io';

import 'package:dashlist/bootstrap.dart';
import 'package:dashlist/src/modules/app/app.dart';
import 'package:dashlist/src/services/http/handshake_override.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() {
  return HttpOverrides.runWithHttpOverrides(
    () => bootstrap(() => const ProviderScope(child: Main())),
    HandshakeOverride(),
  );
}
