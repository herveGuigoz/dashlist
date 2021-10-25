import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mercure_client/mercure_client.dart';

import 'models.dart';

typedef Json = Map<String, dynamic>;

/// State controller of [ShoppingList] ressources.
/// Listen for Mercure events in order to notify listener on updates.
class ShoppingListController extends ListNotifier<ShoppingList> {
  ShoppingListController(Mercure mercure, List<ShoppingList> items)
      : super(items) {
    _subscription = mercure.listen(_onEvent);
  }

  late final StreamSubscription _subscription;

  void _onEvent(MercureEvent event) {
    final json = jsonDecode(event.data) as Json;

    final eventType = json['@type'] as String?;

    if (eventType == ShoppingList.eventType) {
      mapListEventToState(json);
    } else if (eventType == Item.eventType) {
      mapItemEventToState(json);
    }
  }

  /// Update state with [ShoppingList] event from SSE.
  void mapListEventToState(Json json) {
    // For delete event, json contains only the id.
    if (json.length > 1) {
      updateWith(ShoppingList.fromJson(json));
    } else {
      remove(state.firstWhere((e) => e.id == json['id'] as String));
    }
  }

  /// Update state with [Item] event from SSE.
  void mapItemEventToState(Json json) {
    final shoppingListId = json.getshoppingListId();
    bool matchId(ShoppingList list) => list.id == shoppingListId;

    if (state.any(matchId)) {
      final item = Item.fromJson(json);
      updateWith(state.firstWhere(matchId).updateItemsWith(item));
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
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
  void remove(T value) {
    state = state.where((item) => item.match(value)).toList();
  }

  @protected
  void replace(T value) {
    state = state.map((item) => item.match(value) ? value : item).toList();
  }

  @protected
  void updateWith(T value) {
    if (state.any((item) => item.match(value))) {
      replace(value);
    } else {
      add(value);
    }
  }
}

extension on Json {
  String? getshoppingListId({String key = 'shoppingList'}) {
    if (containsKey(key)) {
      return RegExp(r'.+\/(.+)').firstMatch(this[key] as String)?.group(1);
    }
  }
}
