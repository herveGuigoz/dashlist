import 'dart:async';
import 'dart:convert';

import 'package:dashlist/modules/modules.dart';
import 'package:dashlist/services/services.dart';
import 'package:mercure_client/mercure_client.dart';

class MercureSubscriber extends MercureListener {
  MercureSubscriber(Mercure mercure, MessageBus messageBus)
      : super(messageBus) {
    _mercureSubscription = mercure.listen(onMercureEvent);
  }

  late final StreamSubscription _mercureSubscription;

  void dispose() {
    _mercureSubscription.cancel();
  }
}

abstract class MercureListener {
  const MercureListener(this.bus);

  final MessageBus bus;

  void onMercureEvent(MercureEvent event) {
    final json = jsonDecode(event.data) as Json;

    final eventType = json['@type'] as String?;

    if (eventType == ShoppingList.eventType) {
      return onShoppingListEvent(json);
    }

    if (eventType == Item.eventType) {
      return onItemEvent(json);
    }
  }

  /// Update state with [ShoppingList] event from SSE.
  void onShoppingListEvent(Json json) {
    // For delete event, json contains only the id.
    if (json.length > 1) {
      final event = BusEvent.shoppingList(value: ShoppingList.fromJson(json));
      bus.addEvent(event);
    } else if (json.containsKey('id')) {
      bus.addEvent(BusEvent.shoppingListDeleted(uuid: json['id'] as String));
    }
  }

  /// Update state with [Item] event from SSE.
  void onItemEvent(Json json) {
    if (json.length > 1) {
      final event = BusEvent.item(value: Item.fromJson(json));
      bus.addEvent(event);
    }
  }
}
