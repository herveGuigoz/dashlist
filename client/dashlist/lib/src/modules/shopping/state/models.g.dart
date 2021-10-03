// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ShoppingList _$$_ShoppingListFromJson(Map<String, dynamic> json) =>
    _$_ShoppingList(
      id: json['id'] as String,
      name: json['name'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$_ShoppingListToJson(_$_ShoppingList instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'items': instance.items,
    };

_$_Item _$$_ItemFromJson(Map<String, dynamic> json) => _$_Item(
      id: json['id'] as String,
      name: json['name'] as String,
      quantity: json['quantity'] as String?,
      isCompleted: json['isCompleted'] as bool,
      category: Category.fromJson(json['category'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_ItemToJson(_$_Item instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'quantity': instance.quantity,
      'isCompleted': instance.isCompleted,
      'category': instance.category,
    };

_$_Category _$$_CategoryFromJson(Map<String, dynamic> json) => _$_Category(
      name: json['name'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$_CategoryToJson(_$_Category instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
    };
