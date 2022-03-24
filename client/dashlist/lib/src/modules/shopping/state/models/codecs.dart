part of 'models.dart';

mixin ShoppingListCodec {
  static ShoppingList decode(Map<String, dynamic> json, [String? id]) {
    return ShoppingList(
      id: id ?? json['id'] as String,
      name: json['name'] as String,
      items: [
        for (final e in json['items'] as List<dynamic>)
          ItemCodec.decode(e as Map<String, dynamic>, json['id'] as String)
      ],
    );
  }

  static Map<String, dynamic> encode(ShoppingList instance) {
    return <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'items': instance.items.map((e) => e.toJson()).toList(),
    };
  }
}

mixin ItemCodec {
  static Item decode(Map<String, dynamic> json, [String? shoppingListId]) {
    return Item(
      id: json['id'] as String,
      name: json['name'] as String,
      quantity: json['quantity'] as String?,
      isCompleted: json['isCompleted'] as bool,
      category: ItemCategory.fromJson(json['category'] as Map<String, dynamic>),
      shoppingList: shoppingListId ?? json.shoppingListUuid,
    );
  }

  static Map<String, dynamic> encode(Item instance) {
    return <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'quantity': instance.quantity,
      'isCompleted': instance.isCompleted,
      'category': instance.category.toJson(),
      'shoppingList': '/shopping_lists/${instance.shoppingList}',
    };
  }
}

mixin CategoryCodec {
  /// Parse json list of [ItemCategory]
  static List<ItemCategory> decodeResponse(Response response) {
    return [
      for (final json in jsonDecode(response.body) as List<dynamic>)
        ItemCategory.fromJson(json as Map<String, dynamic>)
    ];
  }
}

extension on Map<String, dynamic> {
  String get shoppingListUuid {
    const key = 'shoppingList';

    if (containsKey(key)) {
      return RegExp(r'.+\/(.+)').firstMatch(this[key] as String)!.group(1)!;
    }

    throw Exception('$key not found in json $this');
  }
}
