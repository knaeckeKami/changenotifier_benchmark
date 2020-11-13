import 'package:barbecue/barbecue.dart';
import 'package:flutter/foundation.dart';

import 'benchmark.dart';

class TestResult {
  final int listeners;
  final int updates;
  final String approach;
  final int time;

  TestResult(this.listeners, this.updates, this.approach, this.time);
}

void printTestResults(Iterable<TestResult> results, List<int> updatesToTest,
    {String header}) {
  final resultsByApproach =
      results.toMultiMap(keyFunc: (r) => r.approach, valueFunc: (v) => v);

  final approaches = Set.of(results.map((e) => e.approach));

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
          Row(cells: [
            Cell(header ?? "ValueNotifier benchmark",
                columnSpan: approaches.length * 3)
          ]),
          Row(cells: [
            for (final approach in approaches)
              Cell(approach,
                  columnSpan: 3,
                  style: CellStyle(paddingLeft: 1, paddingRight: 1))
          ]),
          Row(cells: [
            for (final approach in approaches) ...[
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
            for (final approach in approaches) ...[
              if (lastListenersByApproach[approach] !=
                  resultsByApproach[approach][i].listeners)
                Cell(
                    (lastListenersByApproach[approach] =
                            resultsByApproach[approach][i].listeners)
                        .toString(),
                    style: CellStyle(alignment: TextAlignment.MiddleRight),
                    rowSpan: updatesToTest.length),
              Cell(resultsByApproach[approach][i].updates.toString(),
                  style: CellStyle(alignment: TextAlignment.MiddleRight)),
              Cell(resultsByApproach[approach][i].time.toString(),
                  style: CellStyle(alignment: TextAlignment.MiddleRight)),
            ]
          ])
      ]),
      footer: TableSection(rows: [
        Row(cells: [
          for (final approach in approaches) ...[
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
