import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/app.dart';

Future<void> main() async {
  HttpOverrides.runWithHttpOverrides(() {
    runApp(
      const ProviderScope(child: Main()),
    );
  }, HandshakeOverride());
}

/// Accept secure connection with bad certifiacte
class HandshakeOverride extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}
