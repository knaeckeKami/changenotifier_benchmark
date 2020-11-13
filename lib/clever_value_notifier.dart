import 'package:flutter/foundation.dart';

typedef VoidCallback = void Function();

class _Listener {
  _Listener(this.func);
  final VoidCallback func;
  VoidCallback afterNotify;
  void call() {
    if (afterNotify == null) {
      func();
    }
  }
}

class CleverChangeNotifier {
  List<_Listener> _listeners = List<_Listener>();
  int _notifications = 0;
  bool get _notifying => _notifications > 0;

  bool get hasListeners {
    return _listeners.isNotEmpty;
  }

  void addListener(VoidCallback listener) {
    _listeners.add(_Listener(listener));
  }

  void removeListener(VoidCallback listener) {
    for (int i = 0; i < _listeners.length; i++) {
      final _Listener _listener = _listeners[i];
      if (_listener.func == listener && _listener.afterNotify == null) {
        if (_notifying) {
          _listener.afterNotify = () => _listeners.removeAt(i);
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
    _notifications++;
    if (_listeners.isEmpty) {
      _notifications--;
      return;
    }

    if (_listeners != null) {
      final int end = _listeners.length;
      for (int i = 0; i < end; i++) {
        try {
          _listeners[i]();
        } catch (exception, stack) {
          print('error');
        }
      }
      for (int i = end - 1; i >= 0; i--) {
        _listeners[i].afterNotify?.call();
      }
    }

    _notifications--;
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
