import 'package:dashlist/src/modules/app/configuration.dart';
import 'package:dashlist/src/modules/shopping/state/controller.dart';
import 'package:dashlist/src/modules/shopping/state/delegate.dart';
import 'package:dashlist/src/modules/shopping/state/models/models.dart';
import 'package:dashlist/src/services/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mercure_client/mercure_client.dart';

/// '/shopping_lists'
const shoppingListURL = '/shopping_lists';

/// '/list_items'
const shoppingListItemsURL = '/list_items';

/// Mercure with topics for [ShoppingList] and [Item] events
final mercureProvider = Provider((ref) {
  final configuration = ref.watch(configurationProvider);

  return Mercure(
    url: configuration.mercureHub,
    topics: [
      'https://${configuration.baseURL}/$shoppingListURL/{id}',
      'https://${configuration.baseURL}/$shoppingListItemsURL/{id}',
    ],
  );
});

/// Retrieves the collection of [ShoppingList] resources.
final shoppingListCollection = FutureProvider((ref) async {
  final delegate = ref.watch(shoppingListDelegateProvider);
  return delegate.getShoppingLists();
});

/// State provider of [ShoppingList] ressources.
/// @Throw Exception if futureShops wasn't called first.
final shops = StateNotifierProvider<ShoppingListController, List<ShoppingList>>(
  (ref) {
    final response = ref.watch(shoppingListCollection);
    final delegate = ref.read(shoppingListDelegateProvider);
    final messenger = ref.watch(messageBus);

    return response.maybeWhen(
      data: (items) {
        return ShoppingListController(delegate, messenger, items);
      },
      orElse: () {
        throw Exception('provider shoppingListCollection is not initialized');
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
  final delegate = ref.read(shoppingListDelegateProvider);
  return delegate.getCategories();
});
