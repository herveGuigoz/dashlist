// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ShoppingList _$ShoppingListFromJson(Map<String, dynamic> json) {
  return _ShoppingList.fromJson(json);
}

/// @nodoc
class _$ShoppingListTearOff {
  const _$ShoppingListTearOff();

  _ShoppingList call(
      {required String id, required String name, required List<Item> items}) {
    return _ShoppingList(
      id: id,
      name: name,
      items: items,
    );
  }

  ShoppingList fromJson(Map<String, Object> json) {
    return ShoppingList.fromJson(json);
  }
}

/// @nodoc
const $ShoppingList = _$ShoppingListTearOff();

/// @nodoc
mixin _$ShoppingList {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  List<Item> get items => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ShoppingListCopyWith<ShoppingList> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShoppingListCopyWith<$Res> {
  factory $ShoppingListCopyWith(
          ShoppingList value, $Res Function(ShoppingList) then) =
      _$ShoppingListCopyWithImpl<$Res>;
  $Res call({String id, String name, List<Item> items});
}

/// @nodoc
class _$ShoppingListCopyWithImpl<$Res> implements $ShoppingListCopyWith<$Res> {
  _$ShoppingListCopyWithImpl(this._value, this._then);

  final ShoppingList _value;
  // ignore: unused_field
  final $Res Function(ShoppingList) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? items = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      items: items == freezed
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Item>,
    ));
  }
}

/// @nodoc
abstract class _$ShoppingListCopyWith<$Res>
    implements $ShoppingListCopyWith<$Res> {
  factory _$ShoppingListCopyWith(
          _ShoppingList value, $Res Function(_ShoppingList) then) =
      __$ShoppingListCopyWithImpl<$Res>;
  @override
  $Res call({String id, String name, List<Item> items});
}

/// @nodoc
class __$ShoppingListCopyWithImpl<$Res> extends _$ShoppingListCopyWithImpl<$Res>
    implements _$ShoppingListCopyWith<$Res> {
  __$ShoppingListCopyWithImpl(
      _ShoppingList _value, $Res Function(_ShoppingList) _then)
      : super(_value, (v) => _then(v as _ShoppingList));

  @override
  _ShoppingList get _value => super._value as _ShoppingList;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? items = freezed,
  }) {
    return _then(_ShoppingList(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      items: items == freezed
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Item>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ShoppingList implements _ShoppingList {
  const _$_ShoppingList(
      {required this.id, required this.name, required this.items});

  factory _$_ShoppingList.fromJson(Map<String, dynamic> json) =>
      _$$_ShoppingListFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final List<Item> items;

  @override
  String toString() {
    return 'ShoppingList(id: $id, name: $name, items: $items)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _ShoppingList &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.items, items) ||
                const DeepCollectionEquality().equals(other.items, items)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(items);

  @JsonKey(ignore: true)
  @override
  _$ShoppingListCopyWith<_ShoppingList> get copyWith =>
      __$ShoppingListCopyWithImpl<_ShoppingList>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ShoppingListToJson(this);
  }
}

abstract class _ShoppingList implements ShoppingList {
  const factory _ShoppingList(
      {required String id,
      required String name,
      required List<Item> items}) = _$_ShoppingList;

  factory _ShoppingList.fromJson(Map<String, dynamic> json) =
      _$_ShoppingList.fromJson;

  @override
  String get id => throw _privateConstructorUsedError;
  @override
  String get name => throw _privateConstructorUsedError;
  @override
  List<Item> get items => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$ShoppingListCopyWith<_ShoppingList> get copyWith =>
      throw _privateConstructorUsedError;
}

Item _$ItemFromJson(Map<String, dynamic> json) {
  return _Item.fromJson(json);
}

/// @nodoc
class _$ItemTearOff {
  const _$ItemTearOff();

  _Item call(
      {required String id,
      required String name,
      String? quantity,
      required bool isCompleted,
      required Category category}) {
    return _Item(
      id: id,
      name: name,
      quantity: quantity,
      isCompleted: isCompleted,
      category: category,
    );
  }

  Item fromJson(Map<String, Object> json) {
    return Item.fromJson(json);
  }
}

/// @nodoc
const $Item = _$ItemTearOff();

/// @nodoc
mixin _$Item {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get quantity => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  Category get category => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ItemCopyWith<Item> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ItemCopyWith<$Res> {
  factory $ItemCopyWith(Item value, $Res Function(Item) then) =
      _$ItemCopyWithImpl<$Res>;
  $Res call(
      {String id,
      String name,
      String? quantity,
      bool isCompleted,
      Category category});

  $CategoryCopyWith<$Res> get category;
}

/// @nodoc
class _$ItemCopyWithImpl<$Res> implements $ItemCopyWith<$Res> {
  _$ItemCopyWithImpl(this._value, this._then);

  final Item _value;
  // ignore: unused_field
  final $Res Function(Item) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? quantity = freezed,
    Object? isCompleted = freezed,
    Object? category = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: quantity == freezed
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as String?,
      isCompleted: isCompleted == freezed
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      category: category == freezed
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as Category,
    ));
  }

  @override
  $CategoryCopyWith<$Res> get category {
    return $CategoryCopyWith<$Res>(_value.category, (value) {
      return _then(_value.copyWith(category: value));
    });
  }
}

/// @nodoc
abstract class _$ItemCopyWith<$Res> implements $ItemCopyWith<$Res> {
  factory _$ItemCopyWith(_Item value, $Res Function(_Item) then) =
      __$ItemCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id,
      String name,
      String? quantity,
      bool isCompleted,
      Category category});

  @override
  $CategoryCopyWith<$Res> get category;
}

/// @nodoc
class __$ItemCopyWithImpl<$Res> extends _$ItemCopyWithImpl<$Res>
    implements _$ItemCopyWith<$Res> {
  __$ItemCopyWithImpl(_Item _value, $Res Function(_Item) _then)
      : super(_value, (v) => _then(v as _Item));

  @override
  _Item get _value => super._value as _Item;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? quantity = freezed,
    Object? isCompleted = freezed,
    Object? category = freezed,
  }) {
    return _then(_Item(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: quantity == freezed
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as String?,
      isCompleted: isCompleted == freezed
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      category: category == freezed
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as Category,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Item implements _Item {
  const _$_Item(
      {required this.id,
      required this.name,
      this.quantity,
      required this.isCompleted,
      required this.category});

  factory _$_Item.fromJson(Map<String, dynamic> json) => _$$_ItemFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? quantity;
  @override
  final bool isCompleted;
  @override
  final Category category;

  @override
  String toString() {
    return 'Item(id: $id, name: $name, quantity: $quantity, isCompleted: $isCompleted, category: $category)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Item &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.quantity, quantity) ||
                const DeepCollectionEquality()
                    .equals(other.quantity, quantity)) &&
            (identical(other.isCompleted, isCompleted) ||
                const DeepCollectionEquality()
                    .equals(other.isCompleted, isCompleted)) &&
            (identical(other.category, category) ||
                const DeepCollectionEquality()
                    .equals(other.category, category)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(quantity) ^
      const DeepCollectionEquality().hash(isCompleted) ^
      const DeepCollectionEquality().hash(category);

  @JsonKey(ignore: true)
  @override
  _$ItemCopyWith<_Item> get copyWith =>
      __$ItemCopyWithImpl<_Item>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ItemToJson(this);
  }
}

abstract class _Item implements Item {
  const factory _Item(
      {required String id,
      required String name,
      String? quantity,
      required bool isCompleted,
      required Category category}) = _$_Item;

  factory _Item.fromJson(Map<String, dynamic> json) = _$_Item.fromJson;

  @override
  String get id => throw _privateConstructorUsedError;
  @override
  String get name => throw _privateConstructorUsedError;
  @override
  String? get quantity => throw _privateConstructorUsedError;
  @override
  bool get isCompleted => throw _privateConstructorUsedError;
  @override
  Category get category => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$ItemCopyWith<_Item> get copyWith => throw _privateConstructorUsedError;
}

Category _$CategoryFromJson(Map<String, dynamic> json) {
  return _Category.fromJson(json);
}

/// @nodoc
class _$CategoryTearOff {
  const _$CategoryTearOff();

  _Category call({required String name, String? description}) {
    return _Category(
      name: name,
      description: description,
    );
  }

  Category fromJson(Map<String, Object> json) {
    return Category.fromJson(json);
  }
}

/// @nodoc
const $Category = _$CategoryTearOff();

/// @nodoc
mixin _$Category {
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CategoryCopyWith<Category> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryCopyWith<$Res> {
  factory $CategoryCopyWith(Category value, $Res Function(Category) then) =
      _$CategoryCopyWithImpl<$Res>;
  $Res call({String name, String? description});
}

/// @nodoc
class _$CategoryCopyWithImpl<$Res> implements $CategoryCopyWith<$Res> {
  _$CategoryCopyWithImpl(this._value, this._then);

  final Category _value;
  // ignore: unused_field
  final $Res Function(Category) _then;

  @override
  $Res call({
    Object? name = freezed,
    Object? description = freezed,
  }) {
    return _then(_value.copyWith(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$CategoryCopyWith<$Res> implements $CategoryCopyWith<$Res> {
  factory _$CategoryCopyWith(_Category value, $Res Function(_Category) then) =
      __$CategoryCopyWithImpl<$Res>;
  @override
  $Res call({String name, String? description});
}

/// @nodoc
class __$CategoryCopyWithImpl<$Res> extends _$CategoryCopyWithImpl<$Res>
    implements _$CategoryCopyWith<$Res> {
  __$CategoryCopyWithImpl(_Category _value, $Res Function(_Category) _then)
      : super(_value, (v) => _then(v as _Category));

  @override
  _Category get _value => super._value as _Category;

  @override
  $Res call({
    Object? name = freezed,
    Object? description = freezed,
  }) {
    return _then(_Category(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Category implements _Category {
  const _$_Category({required this.name, this.description});

  factory _$_Category.fromJson(Map<String, dynamic> json) =>
      _$$_CategoryFromJson(json);

  @override
  final String name;
  @override
  final String? description;

  @override
  String toString() {
    return 'Category(name: $name, description: $description)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Category &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality()
                    .equals(other.description, description)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(description);

  @JsonKey(ignore: true)
  @override
  _$CategoryCopyWith<_Category> get copyWith =>
      __$CategoryCopyWithImpl<_Category>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CategoryToJson(this);
  }
}

abstract class _Category implements Category {
  const factory _Category({required String name, String? description}) =
      _$_Category;

  factory _Category.fromJson(Map<String, dynamic> json) = _$_Category.fromJson;

  @override
  String get name => throw _privateConstructorUsedError;
  @override
  String? get description => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$CategoryCopyWith<_Category> get copyWith =>
      throw _privateConstructorUsedError;
}
