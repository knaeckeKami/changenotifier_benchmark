import 'dart:collection';

import 'package:flutter/foundation.dart';

class _Entry<T> extends LinkedListEntry<_Entry<T>> {
  _Entry(this.value);
  final T value;
}

class LinkedListValueNotifier<T> implements ValueNotifier<T> {
  LinkedListValueNotifier(this._value);
  final _listeners = LinkedList<_Entry<VoidCallback>>();

  T _value;

  @override
  void addListener(listener) {
    _listeners.add(_Entry(listener));
  }

  @override
  void removeListener(listener) {
    if (_listeners.isEmpty) return;
    _Entry<VoidCallback>? entry = _listeners.first;
    while (entry != null) {
      if (entry.value == listener) {
        entry.unlink();
        return;
      }
      entry = entry.next;
    }
  }

  @override
  T get value => _value;

  @override
  void dispose() {
    _listeners.clear();
  }

  @override
  bool get hasListeners => _listeners.isNotEmpty;

  @override
  void notifyListeners() {
    _Entry<VoidCallback>? entry = _listeners.first;
    final entries = List.generate(_listeners.length, (_) {
      final e = entry;
      entry = entry!.next;
      return e;
    });
    for (final entry in entries) {
      try {
        if (entry!.list == _listeners) entry.value();
      } catch (error) {
        print(error);
      }
    }
  }

  @override
  set value(T newValue) {
    _value = newValue;
    notifyListeners();
  }
}
