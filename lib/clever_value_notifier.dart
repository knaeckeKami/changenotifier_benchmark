import 'package:flutter/foundation.dart';

class CleverChangeNotifier {
  List<VoidCallback> _listeners = List<VoidCallback>();
  List<int> _toRemove = List<int>();
  bool _notifying = false;

  bool get hasListeners {
    return _listeners.isNotEmpty;
  }

  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  void removeListener(VoidCallback listener) {
    for (int i = 0; i < _listeners.length; i++) {
      if (_listeners[i] == listener) {
        if (_notifying) {
          _toRemove.add(i);
        } else {
          _listeners.removeAt(i);
        }
        break;
      }
    }
  }

  void dispose() {
    _listeners = null;
  }

  void notifyListeners() {
    _notifying = true;
    if (_listeners != null) {
      final int start = _listeners.length - 1;
      for (int i = start; i >= 0; i--) {
        try {
          _listeners[i]();
        } catch (exception, stack) {
          print('error');
        }
      }
      for (int i = _toRemove.length - 1; i >= 0; i--) {
        _listeners.removeAt(_toRemove[i]);
      }
      _toRemove.clear();
    }

    _notifying = false;
  }
}

/// A [ChangeNotifier] that holds a single value.
///
/// When [value] is replaced with something that is not equal to the old
/// value as evaluated by the equality operator ==, this class notifies its
/// listeners.
class CleverValueNotifier<T> extends CleverChangeNotifier
    implements ValueListenable<T> {
  /// Creates a [ChangeNotifier] that wraps this value.
  CleverValueNotifier(this._value);

  /// The current value stored in this notifier.
  ///
  /// When the value is replaced with something that is not equal to the old
  /// value as evaluated by the equality operator ==, this class notifies its
  /// listeners.
  @override
  T get value => _value;
  T _value;

  set value(T newValue) {
    if (_value == newValue) return;
    _value = newValue;
    notifyListeners();
  }

  @override
  String toString() => '${describeIdentity(this)}($value)';
}
