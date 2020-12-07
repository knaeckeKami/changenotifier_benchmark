
class TestResult {
  final int listeners;
  final int updates;
  final String approach;
  final int time;

  TestResult(this.listeners, this.updates, this.approach, this.time);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is TestResult &&
              runtimeType == other.runtimeType &&
              listeners == other.listeners &&
              updates == other.updates &&
              approach == other.approach &&
              time == other.time;

  @override
  int get hashCode =>
      listeners.hashCode ^ updates.hashCode ^ approach.hashCode ^ time.hashCode;
}


extension _AverageByRun on Iterable<TestResult> {
  double? averageTime() {
    return this
        .map((e) => e.time)
        .fold(0, (dynamic previousValue, element) => previousValue + element) /
        this.length;
  }
}

extension CountAverageTime on Iterable<TestResult> {
  Iterable<TestResult> calcAverages() {
    final mapGroupedByTime = this.toMultiMap(
        keyFunc: ((value) => _TestResultWithoutTime(
            value.listeners, value.updates, value.approach)),
        valueFunc: (value) => value);

    return mapGroupedByTime.entries.map((e) => TestResult(
      e.key.listeners,
      e.key.updates,
      e.key.approach,
      e.value.averageTime()!.round(),
    ));
  }
}

class _TestResultWithoutTime {
  final int listeners;
  final int updates;
  final String approach;

  _TestResultWithoutTime(this.listeners, this.updates, this.approach);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is _TestResultWithoutTime &&
              runtimeType == other.runtimeType &&
              listeners == other.listeners &&
              updates == other.updates &&
              approach == other.approach;

  @override
  int get hashCode => listeners.hashCode ^ updates.hashCode ^ approach.hashCode;
}


extension ToMultiMap<T> on Iterable<T> {
  Map<K, List<V>> toMultiMap<K, V>({
    required K Function(T) keyFunc,
    required V Function(T) valueFunc,
  }) {

    final map = <K, List<V>>{};

    for (final e in this) {
      final key = keyFunc(e);
      final list = map[key] ?? <V>[];
      list.add(valueFunc(e));
      map[key] = list;
    }

    return map;
  }
}
