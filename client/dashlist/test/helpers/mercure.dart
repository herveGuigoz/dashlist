import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mercure_client/mercure_client.dart';
import 'package:mocktail/mocktail.dart';

Mercure createMercure() {
  final mercure = MercureMock();

  addTearDown(mercure.dispose);

  return mercure;
}

class MercureMock extends Mock implements Mercure {
  final _streamController = StreamController<MercureEvent>();

  @override
  StreamSubscription<MercureEvent> listen(
    void Function(MercureEvent event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return _streamController.stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  void dispose() {
    _streamController.close();
  }
}

