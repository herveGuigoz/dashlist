import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/services.dart';
import 'models.dart';
import 'providers.dart';

final shopActions = Provider((ref) {
  return ShopingListActions(ref.watch(httpClientProvider));
});

class ShopingListActions {
  ShopingListActions(this._client);

  final ApiClient _client;

  Future<void> createNewShoppingList(String name) async {
    await _client.post(shoppingListURL, body: {'name': name});
  }

  /// Edit [ShoppingList] name ressource.
  /// @Throw ApiException
  Future<void> editShoppingListName(ShoppingList value, String name) async {
    await _client.put('$shoppingListURL/${value.id}', body: {'name': name});
  }

  /// Create new [Item] ressource.
  /// @Throw ApiException
  Future<void> createShopItem(ShopItemValueObject value) async {
    await _client.post(shoppingListItemsURL, body: value.toJson());
  }

  /// Edit new [Item] ressource.
  /// @Throw ApiException
  Future<void> editShopItemCompletion(Item item) async {
    await _client.put(
      '$shoppingListItemsURL/${item.id}',
      body: {'isCompleted': !item.isCompleted},
    );
  }

  /// Clear completed shopping list items.
  /// @Throw ApiException
  Future<void> deleteCompletedItems(ShoppingList shoppingList) async {
    await _client.get('$shoppingListURL/${shoppingList.id}/clear');
  }
}
