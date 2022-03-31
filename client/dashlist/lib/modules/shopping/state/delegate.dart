import 'dart:convert';

import 'package:dashlist/modules/modules.dart';
import 'package:dashlist/services/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final shoppingListDelegateProvider = Provider((ref) {
  return FirebaseDelegate();
  // final httpClient = ref.watch(httpClientProvider);
  // return ApiDelegate(httpClient);
});

abstract class ShoppingListDelegate {
  /// Stream for real time updates.
  Stream<List<ShoppingList>> get sse;

  /// Retrieve collection of [ShoppingList] ressources.
  Future<List<ShoppingList>> getShoppingLists();

  /// Create new [ShoppingList] ressource.
  Future<ShoppingList> createNewShoppingList(String name);

  /// Edit [ShoppingList] name.
  Future<void> editShoppingList(ShoppingList value);

  /// Remove given [ShoppingList] ressource.
  Future<void> deleteShoppingList(ShoppingList value);

  /// Create new [Item] ressource.
  Future<Item> createShopItem(ShoppingList list, ShopItemValueObject value);

  /// Retrieve collection of [ItemCategory] ressources.
  Future<List<ItemCategory>> getCategories();

  /// Edit [Item] ressource.
  Future<void> editShopItem(ShoppingList list, Item item);

  /// Clear completed [Item].
  Future<void> deleteCompletedItems(ShoppingList list);
}

class ApiDelegate implements ShoppingListDelegate {
  ApiDelegate(this._client);

  final ApiClient _client;

  @override
  Stream<List<ShoppingList>> get sse => throw UnimplementedError();

  @override
  Future<List<ShoppingList>> getShoppingLists() async {
    final response = await _client.get(shoppingListURL);
    return [
      for (final json in jsonDecode(response.body) as List<dynamic>)
        ShoppingListCodec.decode(json as Map<String, dynamic>)
    ];
  }

  @override
  Future<ShoppingList> createNewShoppingList(String name) async {
    final response = await _client.post(shoppingListURL, body: {'name': name});

    return ShoppingList.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  @override
  Future<void> editShoppingList(ShoppingList value) async {
    final endpoint = '$shoppingListURL/${value.id}';
    await _client.put(endpoint, body: {'name': value.name});
  }

  @override
  Future<void> deleteShoppingList(ShoppingList value) async {
    await _client.delete('$shoppingListURL/${value.id}');
  }

  @override
  Future<Item> createShopItem(
    ShoppingList list,
    ShopItemValueObject value,
  ) async {
    final body = value.toJson();
    final response = await _client.post(shoppingListItemsURL, body: body);

    return Item.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  @override
  Future<void> editShopItem(ShoppingList list, Item item) async {
    await _client.put(
      '$shoppingListItemsURL/${item.id}',
      body: {'isCompleted': item.isCompleted},
    );
  }

  @override
  Future<void> deleteCompletedItems(ShoppingList shoppingList) async {
    await _client.get('$shoppingListURL/${shoppingList.id}/clear');
  }

  @override
  Future<List<ItemCategory>> getCategories() async {
    final response = await _client.get('/categories');
    return CategoryCodec.decodeResponse(response);
  }
}

class FirebaseDelegate extends FirestoreService<ShoppingList>
    implements ShoppingListDelegate {
  @override
  String get path => 'shopping_lists';

  @protected
  String get uuid => const Uuid().v4();

  @override
  ShoppingList decode(String id, Map<String, dynamic> json) {
    return ShoppingListCodec.decode(json, id);
  }

  @override
  Map<String, dynamic> encode(ShoppingList value) => value.toJson();

  @override
  Future<List<ShoppingList>> getShoppingLists() async {
    return readDocuments();
  }

  @override
  Future<ShoppingList> createNewShoppingList(String name) async {
    final item = ShoppingList(id: uuid, name: name, items: []);
    await createDocument(item.id, item);
    return item;
  }

  @override
  Future<void> editShoppingList(ShoppingList value) async {
    await updateDocument(value.id, value);
  }

  @override
  Future<void> deleteShoppingList(ShoppingList value) async {
    await deleteDocument(value.id);
  }

  @override
  Future<Item> createShopItem(
    ShoppingList list,
    ShopItemValueObject value,
  ) async {
    final item = value.toItem();
    await updateDocument(list.id, list.copyWith(items: [...list.items, item]));
    return item;
  }

  @override
  Future<void> editShopItem(ShoppingList list, Item item) async {
    final document = list.copyWith(
      items: [
        for (final value in list.items) value.id == item.id ? item : value
      ],
    );
    await updateDocument(document.id, document);
  }

  @override
  Future<void> deleteCompletedItems(ShoppingList shoppingList) async {
    final document = shoppingList.copyWith(
      items: shoppingList.items.where((item) => !item.isCompleted).toList(),
    );
    await updateDocument(document.id, document);
  }

  @override
  Future<List<ItemCategory>> getCategories() async {
    return const [
      ItemCategory(
        name: 'Bio',
      ),
      ItemCategory(
        name: 'Bricolage',
        description: 'Outillage',
      ),
      ItemCategory(
        name: 'Fruits',
        description: 'Melon, Abricots, Pêches, Nectarines',
      ),
      ItemCategory(
        name: 'Légumes',
        description: 'Concombres, Avocats, Courgettes et Radis',
      ),
      ItemCategory(
        name: 'Plats cuisinés',
        description: 'Pizza',
      ),
      ItemCategory(
        name: 'Viandes',
        description: 'Boeuf, Veau, Porc, Grillades',
      ),
      ItemCategory(
        name: 'Volailles',
        description: 'Poulets, Dinde',
      ),
      ItemCategory(
        name: 'Poissons',
        description: 'Crevettes, Moules, Saumons',
      ),
      ItemCategory(
        name: 'Pâtisseries',
        description: 'Pâtisseries, Viennoiseries',
      ),
      ItemCategory(
        name: 'Frais',
        description: 'Oeufs, Yaourts, Fromages, Charcuterie, Plats cuisinés',
      ),
      ItemCategory(
        name: 'Surgeles',
        description: 'Glaces',
      ),
      ItemCategory(
        name: 'Boissons',
        description: 'Eaux, Lait, Jus de fruits, Sodas, Bières',
      ),
      ItemCategory(
        name: 'Epicerie salee',
        description: 'Apéritifs, Pâtes, Riz, Farine',
      ),
      ItemCategory(
        name: 'Epicerie sucree',
        description: 'Café, Thé, Petit déjeuner, Biscuits, Gâteaux, Farines',
      ),
      ItemCategory(
        name: 'Hygiene et beaute',
        description: 'Soins du corps, Papier toilette, Mouchoirs, Cotons',
      ),
      ItemCategory(
        name: 'Parapharmacie',
        description: 'Dentaire, Crème solaire',
      ),
      ItemCategory(
        name: 'Entretien et Nettoyage',
        description: 'Lessives, Produits nettoyants, Ampoules, Piles',
      ),
      ItemCategory(
        name: 'Jardin',
        description: 'Plantes, Fleurs, Jardinières',
      ),
      ItemCategory(
        name: 'Culture',
        description: 'Consoles, Jeux Vidéos, Livres',
      ),
      ItemCategory(
        name: 'Electroménager',
        description: 'Cafetières, Bouilloires, Gros Electroménager',
      ),
      ItemCategory(
        name: 'Image et Son',
        description: 'TV, Casques et Ecouteurs',
      ),
      ItemCategory(
        name: 'Maison et Décoration',
        description: 'Linge de maison, Linge de maison',
      ),
      ItemCategory(
        name: 'Mode',
        description: 'Vêtements, Chaussures',
      ),
    ];
  }
}
