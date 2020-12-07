import 'package:flutter/foundation.dart';

class ProposedChangeNotifier implements Listenable {
  int _length = 0;
  List<VoidCallback?>? _listeners = List<VoidCallback?>.filled(0, null);
  int _notificationCallStackDepth = 0;
  int _removedListeners = 0;

  bool _debugAssertNotDisposed() {
    assert(() {
      if (_listeners == null) {
        throw FlutterError('A $runtimeType was used after being disposed.\n'
            'Once you have called dispose() on a $runtimeType, it can no longer be used.');
      }
      return true;
    }());
    return true;
  }

  bool get hasListeners {
    assert(_debugAssertNotDisposed());
    return _length > 0;
  }

  void addListener(VoidCallback listener) {
    assert(_debugAssertNotDisposed());

    if (_length == _listeners!.length) {
      if (_length == 0) {
        _listeners = List<VoidCallback?>.filled(1, null);
      } else {
        final newListeners =
            List<VoidCallback?>.filled(_listeners!.length * 2, null);
        for (int i = 0; i < _length; i++) {
          newListeners[i] = _listeners![i];
        }
        _listeners = newListeners;
      }
    }
    _listeners![_length++] = listener;
  }

  void _removeAt(int index) {
    for (int i = index; i < _length - 1; i++) {
      _listeners![i] = _listeners![i + 1];
    }
    _length--;
  }

  void removeListener(VoidCallback listener) {
    assert(_debugAssertNotDisposed());

    for (int i = 0; i < _length; i++) {
      final _listener = _listeners![i];
      if (_listener == listener) {
        if (_notificationCallStackDepth > 0) {
          _listeners![i] = null;
          _removedListeners++;
        } else {
          _removeAt(i);
        }
        break;
      }
    }
  }

  void dispose() {
    assert(_debugAssertNotDisposed());
    _listeners = null;
  }

  void notifyListeners() {
    assert(_debugAssertNotDisposed());

    if (_length == 0) {
      return;
    }
    _notificationCallStackDepth++;

    final int end = _length;
    for (int i = 0; i < end; i++) {
      try {
        _listeners![i]?.call();
      } catch (exception, stack) {
        FlutterError.reportError(FlutterErrorDetails(
          exception: exception,
          stack: stack,
          library: 'foundation library',
          context: ErrorDescription(
              'while dispatching notifications for $runtimeType'),
          informationCollector: () sync* {
            yield DiagnosticsProperty<ProposedChangeNotifier>(
              'The $runtimeType sending notification was',
              this,
              style: DiagnosticsTreeStyle.errorProperty,
            );
          },
        ));
      }
    }

    _notificationCallStackDepth--;

    if (_notificationCallStackDepth == 0 && _removedListeners > 0) {
      // We really remove the listeners when all notifications are done.
      final newLength = _length - _removedListeners;
      final newListeners = List<VoidCallback?>.filled(newLength, null);

      int newIndex = 0;
      for (int i = 0; i < _length; i++) {
        final listener = _listeners![i];
        if (listener != null) {
          newListeners[newIndex++] = listener;
        }
      }

      _removedListeners = 0;
      _length = newLength;
      _listeners = newListeners;
    }
  }
}

/// A [ChangeNotifier] that holds a single value.
///
/// When [value] is replaced with something that is not equal to the old
/// value as evaluated by the equality operator ==, this class notifies its
/// listeners.
class ProposedValueNotifier<T> extends ProposedChangeNotifier
    implements ValueNotifier<T> {
  /// Creates a [ChangeNotifier] that wraps this value.
  ProposedValueNotifier(this._value);

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
