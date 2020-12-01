import 'package:flutter/foundation.dart';

class _Listener {
  _Listener(this.func);
  final VoidCallback func;
  bool active = true;
  void call() {
    if (active) {
      func();
    }
  }
}

class Thomas2ChangeNotifier {
  List<_Listener>? _listeners = <_Listener>[];
  int _notificationCallStackDepth = 0;
  int _removedListeners = 0;
  int? _listenerLengh; // This is the length on the first not recursive call

  bool get hasListeners {
    return _listeners!.isNotEmpty;
  }

  void addListener(VoidCallback listener) {
    _listeners!.add(_Listener(listener));
  }

  void removeListener(VoidCallback listener) {
    for (int i = 0; i < _listeners!.length; i++) {
      final _Listener _listener = _listeners![i];
      if (_listener.func == listener && _listener.active) {
        if (_notificationCallStackDepth > 0) {
          _listener.active = false;
          _removedListeners++;
        } else {
          _listeners!.removeAt(i);
        }
        break;
      }
    }
  }

  void dispose() {
    _listeners = null;
  }

  void notifyListeners() {
    if (_listeners!.isEmpty) {
      return;
    }
    _notificationCallStackDepth++;

    if (_listeners != null) {
      _listenerLengh ??= _listeners!.length;
      for (int i = 0; i < _listenerLengh!; i++) {
        try {
          _listeners![i]();
        } catch (exception, stack) {
          print('error');
        }
      }
    }

    _notificationCallStackDepth--;
    if (_notificationCallStackDepth == 0) {
      if (_removedListeners != 0) {
        final validListenerCount = _listeners!.length - _removedListeners;
        final newListeners = <_Listener>[]..length = validListenerCount;
        int newIndex = 0;
        for (int i = 0; i < _listeners!.length; i++) {
          if (_listeners![i].active) {
            newListeners[newIndex++] = _listeners![i];
          }
        }
        _listeners = newListeners;
      }
      _listenerLengh = null;
      _removedListeners = 0;
    }
  }
}

/// A [ChangeNotifier] that holds a single value.
///
/// When [value] is replaced with something that is not equal to the old
/// value as evaluated by the equality operator ==, this class notifies its
/// listeners.
class Thomas2ValueNotifier<T> extends Thomas2ChangeNotifier
    implements ValueListenable<T> {
  /// Creates a [ChangeNotifier] that wraps this value.
  Thomas2ValueNotifier(this._value);

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
