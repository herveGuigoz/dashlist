import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'models.freezed.dart';
part 'models.g.dart';

/// Parse json list of [ShoppingList]
List<ShoppingList> shoppingListFromJson(String str) {
  return List<ShoppingList>.from(
    (json.decode(str) as List<dynamic>).map<ShoppingList>(
      (dynamic x) => ShoppingList.fromJson(x as Map<String, dynamic>),
    ),
  ).toList();
}

/// Encode list of [ShoppingList]
String shoppingListToJson(List<ShoppingList> data) {
  return json.encode(
    List<dynamic>.from(data.map<Map<String, dynamic>>((x) => x.toJson())),
  );
}

/// Parse json list of [ItemCategory]
List<ItemCategory> categoriesListFromJson(String str) {
  return List<ItemCategory>.from(
    (json.decode(str) as List<dynamic>).map<ItemCategory>(
      (dynamic x) => ItemCategory.fromJson(x as Map<String, dynamic>),
    ),
  ).toList();
}

abstract class Model {
  const Model();

  String get id;

  bool match(Model other) => id == other.id;
}

@freezed
class ShoppingList extends Model with _$ShoppingList {
  const factory ShoppingList({
    required String id,
    required String name,
    required List<Item> items,
  }) = _ShoppingList;

  const ShoppingList._();

  factory ShoppingList.fromJson(Map<String, dynamic> json) =>
      _$ShoppingListFromJson(json);

  static String eventType = 'ShoppingList';

  ShoppingList updateItemsWith(Item item) {
    bool matchId(Item element) => element.id == item.id;

    if (items.any(matchId)) {
      return copyWith(items: items.map((e) => matchId(e) ? item : e).toList());
    }

    return copyWith(items: [...items, item]);
  }
}

@freezed
class Item extends Model with _$Item {
  const factory Item({
    required String id,
    required String name,
    String? quantity,
    required bool isCompleted,
    required ItemCategory category,
  }) = _Item;

  const Item._();

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  static String eventType = 'ListItem';
}

@freezed
class ItemCategory with _$ItemCategory {
  const factory ItemCategory({
    required String name,
    String? description,
  }) = _ItemCategory;

  factory ItemCategory.fromJson(Map<String, dynamic> json) =>
      _$ItemCategoryFromJson(json);
}

class ShopItemValueObject {
  ShopItemValueObject({
    required this.shoppingListId,
    required this.name,
    required this.quantity,
    required this.category,
  });

  final String shoppingListId;
  final String name;
  final String quantity;
  final ItemCategory category;

  Map<String, String> toJson() {
    return {
      'name': name,
      if (quantity.isNotEmpty) 'quantity': quantity,
      'shoppingList': '/shopping_lists/$shoppingListId',
      'category': '/categories/${category.name}'
    };
  }
}
