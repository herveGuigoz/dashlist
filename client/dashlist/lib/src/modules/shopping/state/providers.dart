import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mercure_client/mercure_client.dart';

import '../../../../configuration.dart';
import '../../../services/services.dart';
import 'controller.dart';
import 'models.dart';

/// '/shopping_lists'
const shoppingListURL = '/shopping_lists';

/// '/list_items'
const shoppingListItemsURL = '/list_items';

/// Mercure topics for [ShoppingList] and [Item] events
final topicsProvider = Provider<List<String>>((ref) {
  final appConfiguration = ref.watch(configuration);
  final baseURL = appConfiguration.baseUrl;

  return [
    'https://$baseURL/shopping_lists/{id}',
    'https://$baseURL/list_items/{id}',
  ];
});

final mercureProvider = Provider<Mercure>((ref) {
  final appConfiguration = ref.watch(configuration);
  final topics = ref.read(topicsProvider);

  return Mercure(url: appConfiguration.mercureHub, topics: topics);
});

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

    return response.maybeWhen(
      data: (items) => ShoppingListController(ref.read(mercureProvider), items),
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
