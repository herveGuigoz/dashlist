import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mercure_client/mercure_client.dart';

import 'models.dart';

/// State controller of [ShoppingList] ressources.
/// Listen for Mercure events in order to notify listener on updates.
class ShoppingListController extends ListNotifier<ShoppingList> {
  ShoppingListController(this.mercure, List<ShoppingList> items)
      : super(items) {
    _subscription = mercure.listen(onEvent);
  }

  final Mercure mercure;

  late final StreamSubscription _subscription;

  void onEvent(MercureEvent event) {
    final json = jsonDecode(event.data) as Map<String, dynamic>;
    final eventType = json['@type'] as String?;

    if (eventType == 'ShoppingList') {
      mapShoppingListUpdate(json);
    } else if (eventType == 'ListItem') {
      mapListItemUpdate(json);
    }
  }

  void mapShoppingListUpdate(Map<String, dynamic> json) {
    // For delete event, json contains only the [ShoppingList] id.
    if (json.length > 1) {
      updateWith(ShoppingList.fromJson(json));
    } else if (json.containsKey('@id')) {
      remove(state.firstWhere((e) => e.id == json['@id'] as String));
    }
  }

  void mapListItemUpdate(Map<String, dynamic> json) {
    final shoppingList = state.firstWhereOrNull(
      (list) => list.id == json.getshoppingListId(),
    );

    if (shoppingList != null) {
      updateWith(shoppingList.updateItem(Item.fromJson(json)));
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
    state = state.where((element) => !match(element, value)).toList();
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

extension on Map<String, dynamic> {
  String? getshoppingListId({String key = 'shoppingList'}) {
    if (containsKey(key)) {
      return RegExp(r'.+\/(.+)').firstMatch(this[key] as String)?.group(1);
    }
  }
}

extension IterableExtension<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E element) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
  }
}
