// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'events_bus.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$BusEventTearOff {
  const _$BusEventTearOff();

  _ShoppingListEvent shoppingList({required ShoppingList value}) {
    return _ShoppingListEvent(
      value: value,
    );
  }

  _ShoppingListDeleted shoppingListDeleted({required String uuid}) {
    return _ShoppingListDeleted(
      uuid: uuid,
    );
  }

  _ItemEvent item({required Item value}) {
    return _ItemEvent(
      value: value,
    );
  }
}

/// @nodoc
const $BusEvent = _$BusEventTearOff();

/// @nodoc
mixin _$BusEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ShoppingList value) shoppingList,
    required TResult Function(String uuid) shoppingListDeleted,
    required TResult Function(Item value) item,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(ShoppingList value)? shoppingList,
    TResult Function(String uuid)? shoppingListDeleted,
    TResult Function(Item value)? item,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ShoppingList value)? shoppingList,
    TResult Function(String uuid)? shoppingListDeleted,
    TResult Function(Item value)? item,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ShoppingListEvent value) shoppingList,
    required TResult Function(_ShoppingListDeleted value) shoppingListDeleted,
    required TResult Function(_ItemEvent value) item,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_ShoppingListEvent value)? shoppingList,
    TResult Function(_ShoppingListDeleted value)? shoppingListDeleted,
    TResult Function(_ItemEvent value)? item,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ShoppingListEvent value)? shoppingList,
    TResult Function(_ShoppingListDeleted value)? shoppingListDeleted,
    TResult Function(_ItemEvent value)? item,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BusEventCopyWith<$Res> {
  factory $BusEventCopyWith(BusEvent value, $Res Function(BusEvent) then) =
      _$BusEventCopyWithImpl<$Res>;
}

/// @nodoc
class _$BusEventCopyWithImpl<$Res> implements $BusEventCopyWith<$Res> {
  _$BusEventCopyWithImpl(this._value, this._then);

  final BusEvent _value;
  // ignore: unused_field
  final $Res Function(BusEvent) _then;
}

/// @nodoc
abstract class _$ShoppingListEventCopyWith<$Res> {
  factory _$ShoppingListEventCopyWith(
          _ShoppingListEvent value, $Res Function(_ShoppingListEvent) then) =
      __$ShoppingListEventCopyWithImpl<$Res>;
  $Res call({ShoppingList value});

  $ShoppingListCopyWith<$Res> get value;
}

/// @nodoc
class __$ShoppingListEventCopyWithImpl<$Res>
    extends _$BusEventCopyWithImpl<$Res>
    implements _$ShoppingListEventCopyWith<$Res> {
  __$ShoppingListEventCopyWithImpl(
      _ShoppingListEvent _value, $Res Function(_ShoppingListEvent) _then)
      : super(_value, (v) => _then(v as _ShoppingListEvent));

  @override
  _ShoppingListEvent get _value => super._value as _ShoppingListEvent;

  @override
  $Res call({
    Object? value = freezed,
  }) {
    return _then(_ShoppingListEvent(
      value: value == freezed
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as ShoppingList,
    ));
  }

  @override
  $ShoppingListCopyWith<$Res> get value {
    return $ShoppingListCopyWith<$Res>(_value.value, (value) {
      return _then(_value.copyWith(value: value));
    });
  }
}

/// @nodoc

class _$_ShoppingListEvent
    with DiagnosticableTreeMixin
    implements _ShoppingListEvent {
  const _$_ShoppingListEvent({required this.value});

  @override
  final ShoppingList value;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'BusEvent.shoppingList(value: $value)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'BusEvent.shoppingList'))
      ..add(DiagnosticsProperty('value', value));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _ShoppingListEvent &&
            (identical(other.value, value) ||
                const DeepCollectionEquality().equals(other.value, value)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(value);

  @JsonKey(ignore: true)
  @override
  _$ShoppingListEventCopyWith<_ShoppingListEvent> get copyWith =>
      __$ShoppingListEventCopyWithImpl<_ShoppingListEvent>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ShoppingList value) shoppingList,
    required TResult Function(String uuid) shoppingListDeleted,
    required TResult Function(Item value) item,
  }) {
    return shoppingList(value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(ShoppingList value)? shoppingList,
    TResult Function(String uuid)? shoppingListDeleted,
    TResult Function(Item value)? item,
  }) {
    return shoppingList?.call(value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ShoppingList value)? shoppingList,
    TResult Function(String uuid)? shoppingListDeleted,
    TResult Function(Item value)? item,
    required TResult orElse(),
  }) {
    if (shoppingList != null) {
      return shoppingList(value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ShoppingListEvent value) shoppingList,
    required TResult Function(_ShoppingListDeleted value) shoppingListDeleted,
    required TResult Function(_ItemEvent value) item,
  }) {
    return shoppingList(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_ShoppingListEvent value)? shoppingList,
    TResult Function(_ShoppingListDeleted value)? shoppingListDeleted,
    TResult Function(_ItemEvent value)? item,
  }) {
    return shoppingList?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ShoppingListEvent value)? shoppingList,
    TResult Function(_ShoppingListDeleted value)? shoppingListDeleted,
    TResult Function(_ItemEvent value)? item,
    required TResult orElse(),
  }) {
    if (shoppingList != null) {
      return shoppingList(this);
    }
    return orElse();
  }
}

abstract class _ShoppingListEvent implements BusEvent {
  const factory _ShoppingListEvent({required ShoppingList value}) =
      _$_ShoppingListEvent;

  ShoppingList get value => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  _$ShoppingListEventCopyWith<_ShoppingListEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$ShoppingListDeletedCopyWith<$Res> {
  factory _$ShoppingListDeletedCopyWith(_ShoppingListDeleted value,
          $Res Function(_ShoppingListDeleted) then) =
      __$ShoppingListDeletedCopyWithImpl<$Res>;
  $Res call({String uuid});
}

/// @nodoc
class __$ShoppingListDeletedCopyWithImpl<$Res>
    extends _$BusEventCopyWithImpl<$Res>
    implements _$ShoppingListDeletedCopyWith<$Res> {
  __$ShoppingListDeletedCopyWithImpl(
      _ShoppingListDeleted _value, $Res Function(_ShoppingListDeleted) _then)
      : super(_value, (v) => _then(v as _ShoppingListDeleted));

  @override
  _ShoppingListDeleted get _value => super._value as _ShoppingListDeleted;

  @override
  $Res call({
    Object? uuid = freezed,
  }) {
    return _then(_ShoppingListDeleted(
      uuid: uuid == freezed
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_ShoppingListDeleted
    with DiagnosticableTreeMixin
    implements _ShoppingListDeleted {
  const _$_ShoppingListDeleted({required this.uuid});

  @override
  final String uuid;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'BusEvent.shoppingListDeleted(uuid: $uuid)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'BusEvent.shoppingListDeleted'))
      ..add(DiagnosticsProperty('uuid', uuid));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _ShoppingListDeleted &&
            (identical(other.uuid, uuid) ||
                const DeepCollectionEquality().equals(other.uuid, uuid)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(uuid);

  @JsonKey(ignore: true)
  @override
  _$ShoppingListDeletedCopyWith<_ShoppingListDeleted> get copyWith =>
      __$ShoppingListDeletedCopyWithImpl<_ShoppingListDeleted>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ShoppingList value) shoppingList,
    required TResult Function(String uuid) shoppingListDeleted,
    required TResult Function(Item value) item,
  }) {
    return shoppingListDeleted(uuid);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(ShoppingList value)? shoppingList,
    TResult Function(String uuid)? shoppingListDeleted,
    TResult Function(Item value)? item,
  }) {
    return shoppingListDeleted?.call(uuid);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ShoppingList value)? shoppingList,
    TResult Function(String uuid)? shoppingListDeleted,
    TResult Function(Item value)? item,
    required TResult orElse(),
  }) {
    if (shoppingListDeleted != null) {
      return shoppingListDeleted(uuid);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ShoppingListEvent value) shoppingList,
    required TResult Function(_ShoppingListDeleted value) shoppingListDeleted,
    required TResult Function(_ItemEvent value) item,
  }) {
    return shoppingListDeleted(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_ShoppingListEvent value)? shoppingList,
    TResult Function(_ShoppingListDeleted value)? shoppingListDeleted,
    TResult Function(_ItemEvent value)? item,
  }) {
    return shoppingListDeleted?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ShoppingListEvent value)? shoppingList,
    TResult Function(_ShoppingListDeleted value)? shoppingListDeleted,
    TResult Function(_ItemEvent value)? item,
    required TResult orElse(),
  }) {
    if (shoppingListDeleted != null) {
      return shoppingListDeleted(this);
    }
    return orElse();
  }
}

abstract class _ShoppingListDeleted implements BusEvent {
  const factory _ShoppingListDeleted({required String uuid}) =
      _$_ShoppingListDeleted;

  String get uuid => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  _$ShoppingListDeletedCopyWith<_ShoppingListDeleted> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$ItemEventCopyWith<$Res> {
  factory _$ItemEventCopyWith(
          _ItemEvent value, $Res Function(_ItemEvent) then) =
      __$ItemEventCopyWithImpl<$Res>;
  $Res call({Item value});

  $ItemCopyWith<$Res> get value;
}

/// @nodoc
class __$ItemEventCopyWithImpl<$Res> extends _$BusEventCopyWithImpl<$Res>
    implements _$ItemEventCopyWith<$Res> {
  __$ItemEventCopyWithImpl(_ItemEvent _value, $Res Function(_ItemEvent) _then)
      : super(_value, (v) => _then(v as _ItemEvent));

  @override
  _ItemEvent get _value => super._value as _ItemEvent;

  @override
  $Res call({
    Object? value = freezed,
  }) {
    return _then(_ItemEvent(
      value: value == freezed
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as Item,
    ));
  }

  @override
  $ItemCopyWith<$Res> get value {
    return $ItemCopyWith<$Res>(_value.value, (value) {
      return _then(_value.copyWith(value: value));
    });
  }
}

/// @nodoc

class _$_ItemEvent with DiagnosticableTreeMixin implements _ItemEvent {
  const _$_ItemEvent({required this.value});

  @override
  final Item value;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'BusEvent.item(value: $value)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'BusEvent.item'))
      ..add(DiagnosticsProperty('value', value));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _ItemEvent &&
            (identical(other.value, value) ||
                const DeepCollectionEquality().equals(other.value, value)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(value);

  @JsonKey(ignore: true)
  @override
  _$ItemEventCopyWith<_ItemEvent> get copyWith =>
      __$ItemEventCopyWithImpl<_ItemEvent>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ShoppingList value) shoppingList,
    required TResult Function(String uuid) shoppingListDeleted,
    required TResult Function(Item value) item,
  }) {
    return item(value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(ShoppingList value)? shoppingList,
    TResult Function(String uuid)? shoppingListDeleted,
    TResult Function(Item value)? item,
  }) {
    return item?.call(value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ShoppingList value)? shoppingList,
    TResult Function(String uuid)? shoppingListDeleted,
    TResult Function(Item value)? item,
    required TResult orElse(),
  }) {
    if (item != null) {
      return item(value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ShoppingListEvent value) shoppingList,
    required TResult Function(_ShoppingListDeleted value) shoppingListDeleted,
    required TResult Function(_ItemEvent value) item,
  }) {
    return item(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_ShoppingListEvent value)? shoppingList,
    TResult Function(_ShoppingListDeleted value)? shoppingListDeleted,
    TResult Function(_ItemEvent value)? item,
  }) {
    return item?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ShoppingListEvent value)? shoppingList,
    TResult Function(_ShoppingListDeleted value)? shoppingListDeleted,
    TResult Function(_ItemEvent value)? item,
    required TResult orElse(),
  }) {
    if (item != null) {
      return item(this);
    }
    return orElse();
  }
}

abstract class _ItemEvent implements BusEvent {
  const factory _ItemEvent({required Item value}) = _$_ItemEvent;

  Item get value => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  _$ItemEventCopyWith<_ItemEvent> get copyWith =>
      throw _privateConstructorUsedError;
}
