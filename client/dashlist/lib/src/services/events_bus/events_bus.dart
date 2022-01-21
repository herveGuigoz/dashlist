import 'dart:async';

import 'package:dashlist/src/modules/shopping/state/models/models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'events.dart';
part 'events_bus.freezed.dart';

final messageBus = Provider((ref) => MessageBus());

/// A message bus class. Clients can listen for classes of events, optionally
/// filtered by a string type. This can be used to decouple events sources and
/// event listeners.
class MessageBus {
  MessageBus() : _controller = StreamController.broadcast();

  final StreamController<BusEvent> _controller;

  /// Listen for events on the event bus. 
  /// Clients can filters the events to only those specific ones.
  Stream<BusEvent> onEvent<T extends BusEvent>() {
    return _controller.stream.where((event) => event is T).cast<T>();
  }

  /// Add an event to the event bus.
  void addEvent(BusEvent event) {
    _controller.add(event);
  }

  /// Close (destroy) this [MessageBus]. This is generally not used outside of a
  /// testing context. All stream listeners will be closed and the bus will not
  /// fire any more events.
  void close() {
    _controller.close();
  }
}
