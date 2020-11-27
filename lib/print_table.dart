import 'package:ansicolor/ansicolor.dart';
import 'package:barbecue/barbecue.dart';
import 'package:flutter/foundation.dart';
import 'package:getx_benchmark/testresult.dart';
import 'package:getx_benchmark/testresult.dart';

void printTestResults(Iterable<TestResult> results,
    {String header,
    bool showUpdates = true,
    List<int> updatesToTest = const []}) {
  final resultsByApproach =
      results.toMultiMap(keyFunc: (r) => r.approach, valueFunc: (v) => v);

  final approaches = Set.of(results.map((e) => e.approach));

  final bold = AnsiPen()..white(bold: true);

  int lastListeners;

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
            Cell(bold(header ?? "ValueNotifier benchmark"),
                columnSpan: approaches.length * (showUpdates ? 2 : 1) + 1)
          ]),
          Row(cells: [
            Cell("Listeners", rowSpan: 2),
            for (final approach in approaches)
              Cell(approach,
                  columnSpan: showUpdates ? 2 : 1,
                  style: CellStyle(paddingLeft: 1, paddingRight: 1))
          ]),
          Row(cells: [
            for (final approach in approaches) ...[
              if (showUpdates) Cell("Updates"),
              Cell("Time [µs]"),
            ],
          ]),
        ],
      ),
      body: TableSection(rows: [
        for (var i = 0; i < resultsByApproach.values.first.length; i++)
          Row(cells: [
            if (lastListeners !=
                resultsByApproach[approaches.first][i].listeners)
              Cell(
                  (lastListeners =
                          resultsByApproach[approaches.first][i].listeners)
                      .toString(),
                  style: CellStyle(alignment: TextAlignment.MiddleRight),
                  rowSpan: showUpdates ? updatesToTest.length : 1),
            for (final approach in approaches) ...[
              if (showUpdates)
                Cell(resultsByApproach[approach][i].updates.toString(),
                    style: CellStyle(alignment: TextAlignment.MiddleRight)),
              Cell(resultsByApproach[approach][i].time.toString(),
                  style: CellStyle(alignment: TextAlignment.MiddleRight)),
            ]
          ])
      ]),
      footer: TableSection(rows: [
        Row(cells: [
          Cell(bold("Total Time:")),
          for (final approach in approaches) ...[
            Cell(
              bold(resultsByApproach[approach]
                  .map((e) => e.time)
                  .fold(0, (a, b) => a + b)
                  .toString()),
              columnSpan: showUpdates ? 2 : 1,
              style: CellStyle(
                  alignment: TextAlignment.MiddleRight, borderLeft: false),
            ),
          ]
        ])
      ]));
  final tableString = table.render();
  for (final line in tableString.split("\n")) {
    print(line);
  }
}
