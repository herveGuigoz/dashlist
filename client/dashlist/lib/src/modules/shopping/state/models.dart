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

@freezed
class ShoppingList with _$ShoppingList {
  const factory ShoppingList({
    required String id,
    required String name,
    required List<Item> items,
  }) = _ShoppingList;

  factory ShoppingList.fromJson(Map<String, dynamic> json) =>
      _$ShoppingListFromJson(json);
}

@freezed
class Item with _$Item {
  const factory Item({
    required String id,
    required String name,
    String? quantity,
    required bool isCompleted,
    required Category category,
  }) = _Item;

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
}

@freezed
class Category with _$Category {
  const factory Category({
    required String name,
    String? description,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
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
  final Category category;
}
