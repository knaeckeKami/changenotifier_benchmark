import 'dart:async';

import 'package:barbecue/barbecue.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:getx_benchmark/clever_value_notifier.dart';

typedef BenchMarkFunction = Future<int> Function({int updates, int listeners});

const listenersToTest = [1, 2, 4, 8, 16, 32];
const updatesToTest = [10, 100, 1000, 10000, 100000];

final Map<String, BenchMarkFunction> map = {
  "ValueNotifier": defaultValueNotifier,
  "Value (GetX)": getXValueNotifier,
  "CleverValueNotifier": cleverValueNotifier,
};

Future<int> defaultValueNotifier({final int updates, final int listeners}) {
  final c = Completer<int>();
  final notifier = ValueNotifier<int>(0);
  final timer = Stopwatch()..start();

  for (var i = 0; i < listeners - 1; i++) {
    notifier.addListener(() {});
  }
  timer.stop();
  c.complete(timer.elapsedMicroseconds);

  return c.future;
}

Future<int> cleverValueNotifier({final int updates, final int listeners}) {
  final c = Completer<int>();
  final notifier = CleverValueNotifier<int>(0);
  final timer = Stopwatch()..start();

  for (var i = 0; i < listeners - 1; i++) {
    notifier.addListener(() {});
  }
  timer.stop();
  c.complete(timer.elapsedMicroseconds);

  return c.future;
}

Future<int> getXValueNotifier({final int updates, final int listeners}) {
  final c = Completer<int>();
  final notifier = Value<int>(0);
  final timer = Stopwatch()..start();

  for (var i = 0; i < listeners - 1; i++) {
    notifier.addListener(() {});
  }
  timer.stop();
  c.complete(timer.elapsedMicroseconds);

  return c.future;
}

void main() {
  setUpAll(() async {
    for (final f in map.entries) {
      print("warmup ${f.key}");
      await f.value(updates: 10000, listeners: 10);
    }
  });

  test("benchmark", () async {
    final results = [
      for (final entry in map.entries)
        for (var listeners in listenersToTest)
          for (var updates in updatesToTest)
            TestResult(listeners, updates, entry.key,
                await entry.value(listeners: listeners, updates: updates))
    ];

    final resultsByApproach =
        results.toMultiMap(keyFunc: (r) => r.approach, valueFunc: (v) => v);

    final lastListenersByApproach = <String, int>{};

    final table = Table(
        tableStyle: TableStyle(border: true),
        cellStyle: CellStyle(
            borderBottom: true,
            borderLeft: true,
            borderTop: true,
            borderRight: true,
            paddingRight: 1,
            paddingLeft: 1),
        header: TableSection(
          cellStyle: CellStyle(alignment: TextAlignment.MiddleCenter),
          rows: [
            Row(cells: [Cell("ValueNotifier benchmark", columnSpan: 9)]),
            Row(cells: [
              for (final approach in map.keys)
                Cell(approach,
                    columnSpan: 3,
                    style: CellStyle(paddingLeft: 1, paddingRight: 1))
            ]),
            Row(cells: [
              for (final approach in map.keys) ...[
                Cell("Listeners"),
                Cell("Updates"),
                Cell("Time [µs]"),
              ],
            ]),
          ],
        ),
        body: TableSection(rows: [
          for (var i = 0; i < resultsByApproach.values.first.length; i++)
            Row(cells: [
              for (final approach in map.keys) ...[
                if (lastListenersByApproach[approach] !=
                    resultsByApproach[approach][i].listeners)
                  Cell(
                      (lastListenersByApproach[approach] =
                              resultsByApproach[approach][i].listeners)
                          .toString(),
                      style: CellStyle(alignment: TextAlignment.MiddleRight),
                      rowSpan: listenersToTest.length - 1),
                Cell(resultsByApproach[approach][i].updates.toString(),
                    style: CellStyle(alignment: TextAlignment.MiddleRight)),
                Cell(resultsByApproach[approach][i].time.toString(),
                    style: CellStyle(alignment: TextAlignment.MiddleRight)),
              ]
            ])
        ]),
        footer: TableSection(rows: [
          Row(cells: [
            for (final approach in map.keys) ...[
              Cell("Total Time:", style: CellStyle(borderRight: false)),
              Cell(
                (resultsByApproach[approach]
                    .map((e) => e.time)
                    .fold(0, (a, b) => a + b)
                    .toString()),
                columnSpan: 2,
                style: CellStyle(
                    alignment: TextAlignment.MiddleRight, borderLeft: false),
              ),
            ]
          ])
        ]));
    debugPrint(table.render());

    await Future.delayed(Duration(seconds: 5));
  });
}

class TestResult {
  final int listeners;
  final int updates;
  final String approach;
  final int time;

  TestResult(this.listeners, this.updates, this.approach, this.time);
}

extension _ToMultiMap<T> on Iterable<T> {
  Map<K, List<V>> toMultiMap<K, V>({
    @required K Function(T) keyFunc,
    @required V Function(T) valueFunc,
  }) {
    assert(keyFunc != null);
    assert(valueFunc != null);
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
