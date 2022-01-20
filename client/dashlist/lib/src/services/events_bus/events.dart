part of 'events_bus.dart';

/// An event type for use with [MessageBus].
@freezed
class BusEvent with _$BusEvent {
  const factory BusEvent.shoppingList({
    required ShoppingList value,
  }) = _ShoppingListEvent;

  const factory BusEvent.shoppingListDeleted({
    required String uuid,
  }) = _ShoppingListDeleted;

  const factory BusEvent.item({
    required Item value,
  }) = _ItemEvent;
}


// class BusEvent {
//   BusEvent(this.type, {required this.data});

//   final String type;
//   final Object data;

//   @override
//   String toString() => 'BusEvent(type: $type, data: $data)';
// }
