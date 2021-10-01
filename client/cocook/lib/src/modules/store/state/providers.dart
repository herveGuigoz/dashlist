import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mercure_client/mercure_client.dart';

import '../../../services/services.dart';
import 'models.dart';

const _storeURL = '/stores';

final storesProvider = FutureProvider((ref) async {
  final client = ref.read(httpClientProvider);
  final response = await client.get(_storeURL);

  final data = json.decode(response.body) as List<dynamic>;

  return data
      .map((dynamic e) => Store.fromMap(e as Map<String, dynamic>))
      .toList();
});

final mercureStream = StreamProvider((ref) async* {
  final mercure = Mercure(
    url: 'https://localhost/.well-known/mercure',
    topics: ['https://localhost/shopping_lists/{id}'],
  );

  await for (final event in mercure) {
    yield event;
  }
});

final mercure = StateNotifierProvider<MercureController, List<MercureEvent>>(
  (ref) => MercureController(),
);

class MercureController extends StateNotifier<List<MercureEvent>> {
  MercureController() : super([]) {
    _subscribe();
  }

  final mercure = Mercure(
    url: 'https://localhost/.well-known/mercure',
    topics: ['https://localhost/stores/{id}'],
  );

  late final StreamSubscription<MercureEvent> _sub;

  void _subscribe() {
    _sub = mercure.listen((event) {
      state = [...state, event];
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

abstract class AsyncList<T> extends StateNotifier<AsyncValue<List<T>>> {
  AsyncList() : super(const AsyncValue.loading());
}
