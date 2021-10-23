import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/app.dart';
import 'src/services/http/handshake_override.dart';

Future<void> main() async {
  HttpOverrides.runWithHttpOverrides(() {
    runApp(
      const ProviderScope(child: Main()),
    );
  }, HandshakeOverride());
}
