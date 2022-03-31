import 'dart:convert';

import 'package:dashlist/modules/modules.dart';
import 'package:dashlist/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final shopActions = Provider((ref) {
  final delegate = ref.watch(shoppingListDelegateProvider);
  final bus = ref.watch(messageBus);

  return ShopingListActions(delegate, bus);
});

class ShopingListActions {
  ShopingListActions(this._delegate, this.bus);

  final ShoppingListDelegate _delegate;
  final MessageBus bus;

  /// Create new [ShoppingList] ressource.
  /// @Throw ApiException
  Future<void> createNewShoppingList(String name) async {
    final shoppingList = await _delegate.createNewShoppingList(name);
    bus.addEvent(BusEvent.shoppingList(value: shoppingList));
  }

  /// Edit [ShoppingList] name.
  /// @Throw ApiException
  Future<void> editShoppingListName(ShoppingList value, String name) async {
    final shoppingList = value.copyWith(name: name);
    bus.addEvent(BusEvent.shoppingList(value: shoppingList));
    await _delegate.editShoppingList(shoppingList);
  }

  /// Remove given [ShoppingList] ressource.
  /// @Throw ApiException
  Future<void> deleteShoppingList(ShoppingList value) async {
    bus.addEvent(BusEvent.shoppingListDeleted(uuid: value.id));
    await _delegate.deleteShoppingList(value);
  }

  /// Create new [Item] ressource.
  /// @Throw ApiException
  Future<void> createShopItem(
    ShoppingList list,
    ShopItemValueObject value,
  ) async {
    final item = await _delegate.createShopItem(list, value);
    bus.addEvent(BusEvent.item(value: item));
  }

  /// Edit new [Item] ressource.
  /// @Throw ApiException
  Future<void> editShopItemCompletion(ShoppingList list, Item item) async {
    bus.addEvent(BusEvent.item(value: item));
    await _delegate.editShopItem(list, item);
  }

  /// Clear completed [Item].
  /// @Throw ApiException
  Future<void> deleteCompletedItems(ShoppingList shoppingList) async {
    final items = shoppingList.items.where((i) => !i.isCompleted).toList();
    final event = BusEvent.shoppingList(
      value: shoppingList.copyWith(items: items),
    );
    bus.addEvent(event);
    await _delegate.deleteCompletedItems(shoppingList);
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
