import 'dart:async';

import 'package:dashlist/src/modules/shopping/state/models/models.dart';
import 'package:dashlist/src/modules/shopping/state/subscriber.dart';
import 'package:dashlist/src/services/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef Json = Map<String, dynamic>;

/// State controller of [ShoppingList] ressources.
/// Listen for Mercure events in order to notify listener on updates.
class ShoppingListController extends ListNotifier<ShoppingList> {
  ShoppingListController(
    this.mercureSubscriber,
    MessageBus bus,
    List<ShoppingList> items,
  ) : super(items) {
    _eventBusSubscription = bus.onEvent().listen(onBusEvent);
  }

  final MercureSubscriber mercureSubscriber;
  late final StreamSubscription _eventBusSubscription;

  void onBusEvent(BusEvent event) {
    event.when(
      shoppingList: update,
      shoppingListDeleted: delete,
      item: updateListItems,
    );
  }

  void updateListItems(Item value) {
    // todo: check if list exist
    var list = state.firstWhere((e) => e.id == value.shoppingList);
    final itemExist = list.items.any((item) => item.id == value.id);

    if (itemExist) {
      list = list.copyWith(
        items: [
          for (final item in list.items)
            if (value.id == item.id) value else item
        ],
      );
    } else {
      list = list.copyWith(items: [...list.items, value]);
    }

    update(list);
  }

  @override
  void dispose() {
    mercureSubscriber.dispose();
    _eventBusSubscription.cancel();
    super.dispose();
  }
}

/// Helper to provide utilities on List updates
abstract class ListNotifier<T extends Model> extends StateNotifier<List<T>> {
  ListNotifier(List<T> state) : super(state);

  @protected
  void add(T value) {
    state = [...state, value];
  }

  @protected
  void delete(String id) {
    state = [
      for (final item in state)
        if (id != item.id) item
    ];
  }

  @protected
  void replace(T value) {
    state = [
      for (final item in state)
        if (item.match(value)) value else item
    ];
  }

  @protected
  void update(T value) {
    if (state.any((item) => item.match(value))) {
      replace(value);
    } else {
      add(value);
    }
  }
}
