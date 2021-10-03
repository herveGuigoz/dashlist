import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mercure_client/mercure_client.dart';

import '../../../services/services.dart';
import 'models.dart';

typedef ShoppingListRef
    = StateNotifierProvider<ShoppingListController, ShoppingListState>;

const _shoppingListURL = '/shopping_lists';

final shoppingLists = FutureProvider((ref) async {
  final client = ref.read(httpClientProvider);

  final response = await client.get(_shoppingListURL);

  return shoppingListFromJson(response.body);
});

final dashlistRef = ShoppingListRef(
  (ref) => ref.watch(shoppingLists).maybeWhen(
        data: (items) => ShoppingListController(items),
        orElse: () {
          throw Exception('ShoppingListController is not initialized');
        },
      ),
);

class ShoppingListController extends StateNotifier<ShoppingListState> {
  ShoppingListController(List<ShoppingList> items)
      : super(ShoppingListState.fromIterable(items)) {
    _subscribe();
  }

  StreamSubscription? _subscription;

  void _subscribe() {
    _subscription = Mercure(
      url: 'https://localhost/.well-known/mercure',
      topics: ['https://localhost/shopping_lists/{id}'],
    ).listen((event) {
      final item = ShoppingList.fromJson(event.data as Map<String, dynamic>);
      state = state.update(item);
    });
  }

  // void update(ShoppingList value) {
  //   if (state.any((list) => list.id == value.id)) {}
  // }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

class ShoppingListState {
  ShoppingListState._(this._root);

  ShoppingListState.empty() : _root = <String, ShoppingList>{};

  ShoppingListState.fromIterable(List<ShoppingList> iterable)
      : _root = {for (final item in iterable) item.name: item};

  final Map<String, ShoppingList> _root;

  Iterable<ShoppingList> get value => _root.values;

  ShoppingListState update(ShoppingList item) {
    _root[item.id] = item;
    return ShoppingListState._(_root);
  }
}
