import 'dart:convert';

import 'package:dashlist/src/modules/shopping/state/models/models.dart';
import 'package:dashlist/src/modules/shopping/state/providers.dart';
import 'package:dashlist/src/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final shopActions = Provider((ref) {
  final httpClient = ref.watch(httpClientProvider);
  final bus = ref.watch(messageBus);

  return ShopingListActions(httpClient, bus);
});

class ShopingListActions extends Messenger {
  ShopingListActions(this._client, MessageBus bus) : super(bus);

  final ApiClient _client;

  /// Create new [ShoppingList] ressource.
  /// @Throw ApiException
  Future<void> createNewShoppingList(String name) async {
    final response = await _client.post(shoppingListURL, body: {'name': name});
    onNewShoppingList(response);
  }

  /// Edit [ShoppingList] name.
  /// @Throw ApiException
  Future<void> editShoppingListName(ShoppingList value, String name) async {
    onShoppingUpdate(value, name);
    final endpoint = '$shoppingListURL/${value.id}';
    await _client.put(endpoint, body: {'name': name});
  }

  /// Remove given [ShoppingList] ressource.
  /// @Throw ApiException
  Future<void> deleteShoppingList(ShoppingList value) async {
    onShoppingListDeleted(value);
    await _client.delete('$shoppingListURL/${value.id}');
  }

  /// Create new [Item] ressource.
  /// @Throw ApiException
  Future<void> createShopItem(ShopItemValueObject value) async {
    final body = value.toJson();
    final response = await _client.post(shoppingListItemsURL, body: body);
    onNewShopItem(value, response);
  }

  /// Edit new [Item] ressource.
  /// @Throw ApiException
  Future<void> editShopItemCompletion(Item item) async {
    onShopItemCompletion(item);
    await _client.put(
      '$shoppingListItemsURL/${item.id}',
      body: {'isCompleted': !item.isCompleted},
    );
  }

  /// Clear completed [Item].
  /// @Throw ApiException
  Future<void> deleteCompletedItems(ShoppingList shoppingList) async {
    onCompletedItems(shoppingList);
    await _client.get('$shoppingListURL/${shoppingList.id}/clear');
  }
}

abstract class Messenger {
  Messenger(this.bus);

  final MessageBus bus;

  void onNewShoppingList(Response response) {
    final shoppingList = ShoppingList.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );

    bus.addEvent(BusEvent.shoppingList(value: shoppingList));
  }

  void onNewShopItem(ShopItemValueObject request, Response response) {
    final item = Item.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );

    bus.addEvent(BusEvent.item(value: item));
  }

  void onShoppingUpdate(ShoppingList value, String name) {
    final shoppingList = value.copyWith(name: name);
    bus.addEvent(BusEvent.shoppingList(value: shoppingList));
  }

  void onShopItemCompletion(Item item) {
    final event = BusEvent.item(
      value: item.copyWith(isCompleted: !item.isCompleted),
    );

    bus.addEvent(event);
  }

  void onShoppingListDeleted(ShoppingList value) {
    bus.addEvent(BusEvent.shoppingListDeleted(uuid: value.id));
  }

  void onCompletedItems(ShoppingList shoppingList) {
    final items = shoppingList.items.where((i) => !i.isCompleted).toList();

    final event = BusEvent.shoppingList(
      value: shoppingList.copyWith(items: items),
    );

    bus.addEvent(event);
  }
}
