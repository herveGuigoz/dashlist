import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mercure_client/mercure_client.dart';

import '../../../services/services.dart';
import '../../app/configuration.dart';
import 'models.dart';

/// '/shopping_lists'
const shoppingListURL = '/shopping_lists';

/// '/list_items'
const shoppingListItemsURL = '/list_items';

/// Retrieves the collection of [ShoppingList] resources.
final shoppingListCollection = FutureProvider((ref) async {
  final client = ref.read(httpClientProvider);

  final response = await client.get(shoppingListURL);

  return shoppingListFromJson(response.body);
});

/// State provider of [ShoppingList] ressources.
/// @Throw Exception if futureShops wasn't called first.
final shops = StateNotifierProvider<ShoppingListController, List<ShoppingList>>(
  (ref) {
    final response = ref.watch(shoppingListCollection);
    final appConfiguration = ref.read(configuration);

    return response.maybeWhen(
      data: (items) => ShoppingListController(appConfiguration, items),
      orElse: () {
        throw Exception('ShoppingListController is not initialized');
      },
    );
  },
);

/// Retrieve a [ShoppingList] ressources from his uuid.
final shop = Provider.family.autoDispose<ShoppingList, String>((ref, uuid) {
  final ressources = ref.watch(shops);
  return ressources.firstWhere((ressource) => ressource.id == uuid);
});

final scopedShoppingList = Provider.autoDispose<ShoppingList>(
  (ref) => throw Exception('scopedShoppingList not found in context'),
);

/// Groups the items by category.
final shopItems = Provider.autoDispose.family<Map<String, List<Item>>, String>(
  (ref, id) {
    final shoppingList = ref.watch(shop(id));
    final map = <String, List<Item>>{};
    for (final item in shoppingList.items) {
      (map[item.category.name] ??= []).add(item);
    }
    return map;
  },
);

/// Retrieves the collection of [Category] resources.
final categoriesProvider = FutureProvider<List<ItemCategory>>((ref) async {
  final response = await ref.read(httpClientProvider).get('/categories');
  return categoriesListFromJson(response.body);
});

/// State controller of [ShoppingList] ressources.
/// Listen for Mercure events in order to notify listener on updates.
class ShoppingListController extends ListNotifier<ShoppingList> {
  ShoppingListController(this.configuration, List<ShoppingList> items)
      : super(items) {
    _subscription = Mercure(url: mercureHub, topics: [topic]).listen(_onEvent);
  }

  final Configuration configuration;

  /// Api endpoint
  String get baseURL => configuration.baseUrl;

  /// URL to receive updates from mercure.
  String get mercureHub => configuration.mercureHub;

  /// Mercure topics for [ShoppingList] events
  String get topic => 'https://$baseURL/shopping_lists/{id}';

  late final StreamSubscription _subscription;

  void _onEvent(MercureEvent event) {
    final json = jsonDecode(event.data) as Map<String, dynamic>;
    // If mercure event contains `name` key that either an creation or update,
    // as for delete event, json contains only the id.
    if (json.containsKey('name')) {
      updateWith(ShoppingList.fromJson(json));
    } else {
      remove(state.firstWhere((e) => e.id == json['id'] as String));
    }
  }

  @override
  bool match(ShoppingList value, ShoppingList other) => value.id == other.id;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

/// Helper to provide utilities on List updates
abstract class ListNotifier<T> extends StateNotifier<List<T>> {
  ListNotifier(List<T> state) : super(state);

  @protected
  bool match(T value, T other);

  @protected
  void add(T value) {
    state = [...state, value];
  }

  @protected
  void remove(T value) {
    state = state.where((element) => match(element, value)).toList();
  }

  @protected
  void replace(T value) {
    state = state.map((item) => match(item, value) ? value : item).toList();
  }

  @protected
  void updateWith(T value) {
    if (state.any((element) => match(element, value))) {
      replace(value);
    } else {
      add(value);
    }
  }
}
