import 'package:dashlist/src/core/result/result.dart';
import 'package:dashlist/src/modules/authentication/logic/interface.dart';
import 'package:flutter/widgets.dart';

/// Bridge abstraction between hydrated notifiers and UI to handle async events
/// and errors.
class AuthViewModel extends ChangeNotifier {
  AuthViewModel(this.authenticationInterface);

  final AuthenticationInterface authenticationInterface;

  late final isLoading = Property<bool>(false, notifyListeners);

  late final error = Property<String?>(null, notifyListeners);

  Future<void> execute<R>(Future<Result<R>> Function() future) async {
    isLoading.value = true;
    final result = await future();
    result.onError((failure) => error.value = failure.message);
    isLoading.value = false;
  }
}

class Property<T> {
  Property(T initialValue, this.notifyListeners) : _value = initialValue;

  late T _value;
  final void Function() notifyListeners;

  T get value => _value;

  set value(T value) {
    if (_value != value) {
      _value = value;
      notifyListeners();
    }
  }
}
