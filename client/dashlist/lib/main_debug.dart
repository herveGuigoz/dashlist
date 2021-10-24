import 'dart:io';

import 'package:dashlist_theme/dashlist_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_json_view/flutter_json_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mercure_client/mercure_client.dart';

import 'configuration.dart';
import 'src/components/components.dart';
import 'src/services/http/handshake_override.dart';

Future<void> main() async {
  HttpOverrides.runWithHttpOverrides(() {
    runApp(
      const ProviderScope(child: Debug()),
    );
  }, HandshakeOverride());
}

final uri = Uri().replace(query: '?topic=coucou');
final mercureStream = StreamProvider((ref) async* {
  final config = ref.watch(configuration);
  yield* Mercure(
    url: ref.watch(configuration).mercureHub,
    topics: [
      'https://${config.baseUrl}/shopping_lists/{id}',
      'https://${config.baseUrl}/list_items/{id}',
    ],
  );
});

class Debug extends ConsumerWidget {
  const Debug({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stream = ref.watch(mercureStream);

    return MaterialApp(
      theme: DashlistTheme.light,
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(32),
          child: stream.when(
            data: (event) {
              print(event.data);
              return JsonView.string(event.data);
            },
            loading: () => const Loader(),
            error: (error, _) => Error(error: error),
          ),
        ),
      ),
    );
  }
}
