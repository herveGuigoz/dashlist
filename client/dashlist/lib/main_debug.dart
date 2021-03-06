import 'dart:io';

import 'package:dashlist/bootstrap.dart';
import 'package:dashlist/components/components.dart';
import 'package:dashlist/modules/app/configuration.dart';
import 'package:dashlist/services/services.dart';
import 'package:dashlist_theme/dashlist_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_json_view/flutter_json_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mercure_client/mercure_client.dart';

Future<void> main() {
  return HttpOverrides.runWithHttpOverrides(
    () => bootstrap(() => const ProviderScope(child: Debug())),
    HandshakeOverride(),
  );
}

final mercureStream = StreamProvider((ref) async* {
  final configuration = ref.watch(configurationProvider);
  yield* Mercure(
    url: configuration.mercureHub,
    topics: [
      'https://${configuration.baseURL}/shopping_lists/{id}',
      'https://${configuration.baseURL}/list_items/{id}',
    ],
  );
});

class Debug extends ConsumerWidget {
  const Debug({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stream = ref.watch(mercureStream);

    return MaterialApp(
      theme: AppThemeData.light,
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(32),
          child: stream.when(
            data: (event) => JsonView.string(event.data),
            loading: () => const Loader(),
            error: (error, _) => Error(error: error),
          ),
        ),
      ),
    );
  }
}
