// ignore_for_file: use_setters_to_change_properties
import 'dart:async';
import 'dart:developer';

import 'package:dashlist/modules/modules.dart';
import 'package:dashlist/services/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef Json = Map<String, dynamic>;

/// State controller of [ShoppingList] ressources.
/// Listen for Mercure events in order to notify listener on updates.
class ShoppingListController extends ListNotifier<ShoppingList> {
  ShoppingListController(
    ShoppingListDelegate delegate,
    MessageBus bus,
    List<ShoppingList> items,
  ) : super(items) {
    _eventBusSubscription = bus.onEvent().listen(onBusEvent);
    _sseSubscription = delegate.sse.listen(onSseEvent);
  }

  late final StreamSubscription _eventBusSubscription;
  late final StreamSubscription _sseSubscription;

  void onSseEvent(List<ShoppingList> event) {
    state = event;
  }

  void onBusEvent(BusEvent event) {
    event.when(
      shoppingList: update,
      shoppingListDeleted: delete,
      item: updateListItems,
    );
  }

  void updateListItems(Item value) {
    log(value.toString());
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
    _eventBusSubscription.cancel();
    _sseSubscription.cancel();
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
