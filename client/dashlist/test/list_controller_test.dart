import 'dart:convert';

import 'package:dashlist/src/modules/shopping/shopping.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mercure_client/mercure_client.dart';

import 'helpers/helpers.dart';

void main() {
  group('ShoppingListController', () {
    test('load json', () async {
      final newListEvent = await loadJson('/data/new_list_event.json');
      final json = jsonDecode(newListEvent) as Map<String, dynamic>;

      final mercure = createMercure();

      final container = createContainer(
        overrides: [
          shoppingListCollection.overrideWithValue(const AsyncData([])),
          mercureProvider.overrideWithValue(mercure),
        ],
      );

      container.read(shops.notifier).mapShoppingListUpdate(json);

      expect(container.read(shops).length, equals(1));
    });
  });
}
