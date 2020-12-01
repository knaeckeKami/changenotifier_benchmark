import 'dart:collection';

import 'package:flutter/foundation.dart';


class _ListenerEntry extends LinkedListEntry<_ListenerEntry> {
  _ListenerEntry(this.listener, this.id);
  final String id;
  final VoidCallback listener;
}

/// A class that can be extended or mixed in that provides a change notification
/// API using [VoidCallback] for notifications.
///
/// It is O(1) for adding listeners and O(N) for removing listeners and dispatching
/// notifications (where N is the number of listeners).
///
/// See also:
///
///  * [CustomLinkedListChangeNotifier], which is a [ChangeNotifier] that wraps a single value.
class ChangeNotifier implements Listenable {
  LinkedList<_ListenerEntry>? _listeners = LinkedList<_ListenerEntry>();
  _ListenerEntry? _notifyCursor;
  _ListenerEntry? _notifyLimit;

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

  /// Whether any listeners are currently registered.
  ///
  /// Clients should not depend on this value for their behavior, because having
  /// one listener's logic change when another listener happens to start or stop
  /// listening will lead to extremely hard-to-track bugs. Subclasses might use
  /// this information to determine whether to do any work when there are no
  /// listeners, however; for example, resuming a [Stream] when a listener is
  /// added and pausing it when a listener is removed.
  ///
  /// Typically this is used by overriding [addListener], checking if
  /// [hasListeners] is false before calling `super.addListener()`, and if so,
  /// starting whatever work is needed to determine when to call
  /// [notifyListeners]; and similarly, by overriding [removeListener], checking
  /// if [hasListeners] is false after calling `super.removeListener()`, and if
  /// so, stopping that same work.
  @protected
  bool get hasListeners {
    assert(_debugAssertNotDisposed());
    return _listeners?.isNotEmpty ?? false;
  }

  /// Register a closure to be called when the object changes.
  ///
  /// If the given closure is already registered, an additional instance is
  /// added, and must be removed the same number of times it is added before it
  /// will stop being called.
  ///
  /// This method must not be called after [dispose] has been called.
  ///
  /// {@template flutter.foundation.ChangeNotifier.addListener}
  /// If a listener is added twice, and is removed once during an iteration
  /// (e.g. in response to a notification), it will still be called again. If,
  /// on the other hand, it is removed as many times as it was registered, then
  /// it will no longer be called. This odd behavior is the result of the
  /// [ChangeNotifier] not being able to determine which listener is being
  /// removed, since they are identical, therefore it will conservatively still
  /// call all the listeners when it knows that any are still registered.
  ///
  /// This surprising behavior can be unexpectedly observed when registering a
  /// listener on two separate objects which are both forwarding all
  /// registrations to a common upstream object.
  /// {@endtemplate}
  ///
  /// See also:
  ///
  ///  * [removeListener], which removes a previously registered closure from
  ///    the list of closures that are notified when the object changes.
  @override
  void addListener(VoidCallback listener, [String id = '']) {
    assert(_debugAssertNotDisposed());
    // if (_notifyCursor != null) {
    //   _listenersToAddAfterNotify.add(_ListenerEntry(listener, id));
    // } else {
    //   _listeners?.add(_ListenerEntry(listener, id));
    // }
    if (_notifyCursor != null) {
      _listeners?.add(_ListenerEntry(listener, id));
    } else {
      _listeners?.add(_ListenerEntry(listener, id));
    }
  }

  void printListeners(String prefix) {
    String s;
    s = '$prefix : ';
    for (var p = _listeners?.first; p != null; p = p.next) {
      s += p.id;
    }
    s += ' - cursor: ${_notifyCursor?.id} - ${_notifyLimit?.id}';
    print(s);
  }

  /// Remove a previously registered closure from the list of closures that are
  /// notified when the object changes.
  ///
  /// If the given listener is not registered, the call is ignored.
  ///
  /// This method must not be called after [dispose] has been called.
  ///
  /// {@macro flutter.foundation.ChangeNotifier.addListener}
  ///
  /// See also:
  ///
  ///  * [addListener], which registers a closure to be called when the object
  ///    changes.
  @override
  void removeListener(VoidCallback listener) {
    assert(_debugAssertNotDisposed());
    if (_listeners!.isEmpty) return;

    for (_ListenerEntry? entry = _listeners?.first;
    entry != null;
    entry = entry.next) {
      if (entry.listener == listener) {
        if (entry == _notifyLimit) {
          _notifyLimit = _notifyLimit?.previous;

          if (entry == _notifyCursor) {
            _notifyCursor = _notifyLimit;
          }
        } else {
          if (entry == _notifyCursor) {
            _notifyCursor = _notifyCursor?.previous;
          }
        }
        entry.unlink();
        return;
      }
    }
  }

  /// Discards any resources used by the object. After this is called, the
  /// object is not in a usable state and should be discarded (calls to
  /// [addListener] and [removeListener] will throw after the object is
  /// disposed).
  ///
  /// This method should only be called by the object's owner.
  @mustCallSuper
  void dispose() {
    assert(_debugAssertNotDisposed());
    _listeners = null;
  }

  /// Call all the registered listeners.
  ///
  /// Call this method whenever the object changes, to notify any clients the
  /// object may have changed. Listeners that are added during this iteration
  /// will not be visited. Listeners that are removed during this iteration will
  /// not be visited after they are removed.
  ///
  /// Exceptions thrown by listeners will be caught and reported using
  /// [FlutterError.reportError].
  ///
  /// This method must not be called after [dispose] has been called.
  ///
  /// Surprising behavior can result when reentrantly removing a listener (e.g.
  /// in response to a notification) that has been registered multiple times.
  /// See the discussion at [removeListener].
  @protected
  @visibleForTesting
  void notifyListeners() {
    assert(_debugAssertNotDisposed());
    if (_listeners!.isEmpty) return;

    _notifyLimit = _listeners?.last;
    _notifyCursor = _listeners?.first;
    do {
      try {
        _notifyCursor?.listener();
      } catch (exception, stack) {
        FlutterError.reportError(FlutterErrorDetails(
          exception: exception,
          stack: stack,
          library: 'foundation library',
          context: ErrorDescription(
              'while dispatching notifications for $runtimeType'),
          informationCollector: () sync* {
            yield DiagnosticsProperty<ChangeNotifier>(
              'The $runtimeType sending notification was',
              this,
              style: DiagnosticsTreeStyle.errorProperty,
            );
          },
        ));
      }

      /// In case that the first listener removes itself
      /// _notifyCursor could be null here.
      if (_notifyCursor == null) {
        /// in case that the List is now empty
        if (_listeners!.isEmpty) return;

        _notifyCursor = _listeners?.first;
      } else {
        _notifyCursor = _notifyCursor?.next;
      }
    } while (_notifyCursor != null && _notifyCursor?.previous != _notifyLimit);

    _notifyCursor = null;
    _notifyLimit = null;
  }
}


/// A [ChangeNotifier] that holds a single value.
///
/// When [value] is replaced with something that is not equal to the old
/// value as evaluated by the equality operator ==, this class notifies its
/// listeners.
class CustomLinkedListChangeNotifier<T> extends ChangeNotifier implements ValueListenable<T> {
  /// Creates a [ChangeNotifier] that wraps this value.
  CustomLinkedListChangeNotifier(this._value);

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