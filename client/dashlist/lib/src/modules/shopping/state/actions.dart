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

  Future<void> createNewShoppingList() async {}

  /// Edit [ShoppingList] name ressource.
  /// @Throw ApiException
  Future<void> editShoppingListName(ShoppingList value, String input) async {
    await _client.put('$shoppingListURL/${value.id}', body: {'name': input});
  }

  /// Create new [Item] ressource.
  /// @Throw ApiException
  Future<void> createShopItem(ShopItemValueObject value) async {
    await _client.delete(shoppingListURL);
  }

  /// Clear completed shopping list items.
  /// @Throw ApiException
  Future<void> deleteCompletedItems(ShoppingList shoppingList) async {
    await _client.delete(shoppingListURL);
  }
}
