import 'package:flutter/foundation.dart';

class SimpleChangeNotifier implements Listenable {
  final _listeners = List<VoidCallback>();
  void notifyListeners() {
    for (final updater in _listeners) {
      updater();
    }
  }

  VoidCallback addListener(VoidCallback listener) {
    _listeners.add(listener);
    return () => _listeners.remove(listener);
  }
    
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }
}

class SimpleValue<T> extends SimpleChangeNotifier implements ValueListenable<T> {
  SimpleValue([this._value]);

  T _value;

  T get value {
    return _value;
  }

  set value(T newValue) {
    if (_value == newValue) return;
    _value = newValue;
    notifyListeners();
  }
}