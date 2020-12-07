import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:getx_benchmark/notifiers/factories.dart';
import 'package:getx_benchmark/print_table.dart';
import 'package:getx_benchmark/testresult.dart';

const _benchmarkRuns = 10000;
const listenersToTest = [1, 2, 4, 8, 16];

int runBenchmark({
  required ValueNotifierFactory creator,
  required final int listeners,
}) {
  final notifier = creator(0);
  final listenersList = <VoidCallback>[
    for (var i = 0; i < listeners; i++) () {}
  ];

  for (var i = 0; i < listeners; i++) {
    notifier.addListener(listenersList[i]);
  }
  final timer = Stopwatch()..start();
  for (var i = 0; i < listeners; i++) {
    notifier.removeListener(listenersList[i]);
  }
  timer.stop();

  return timer.elapsedMicroseconds;
}

void main() {
  setUpAll(() async {
    for (final f in factories.entries) {
      print("warmup ${f.key}");
      runBenchmark(creator: f.value, listeners: 100);
    }
  });

  test("benchmark", () async {
    final results = [
      for (var i = 0; i < _benchmarkRuns; i++)
        for (final entry in factories.entries)
          for (var listeners in listenersToTest)
            TestResult(
              listeners,
              0,
              entry.key,
              runBenchmark(
                creator: entry.value,
                listeners: listeners,
              ),
            )
    ].calcAverages();

    printTestResults(results,
        header: "Remove Listeners benchmark test", showUpdates: false);

    //delay to be sure the big table is printed before finishing so the table is printed as whole;
    await Future.delayed(Duration(seconds: 5));
  });
}
