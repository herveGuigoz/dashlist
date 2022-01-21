import 'dart:convert';

import 'package:dashlist/src/services/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'codecs.dart';
part 'models.freezed.dart';
part 'models.g.dart';

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

  factory ShoppingList.fromJson(Map<String, dynamic> json) {
    return ShoppingListCodec.decode(json);
  }

  Map<String, dynamic> toJson() {
    return ShoppingListCodec.encode(this);
  }

  static String eventType = 'ShoppingList';
}

@freezed
class Item extends Model with _$Item {
  const factory Item({
    required String id,
    required String name,
    String? quantity,
    required bool isCompleted,
    required ItemCategory category,
    required String shoppingList,
  }) = _Item;

  const Item._();

  factory Item.fromJson(Map<String, dynamic> json) {
    return ItemCodec.decode(json);
  }

  Map<String, dynamic> toJson() {
    return ItemCodec.encode(this);
  }

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
