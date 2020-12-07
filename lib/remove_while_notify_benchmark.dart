import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:getx_benchmark/notifiers/factories.dart';
import 'package:getx_benchmark/print_table.dart';
import 'package:getx_benchmark/testresult.dart';

const _benchmarkRuns = 10000;
const listenersToTest = [1, 2, 4, 8, 16];

Future<int> runBenchmark({
  required ValueNotifierFactory creator,
  required final int listeners,
}) async {
  final c = Completer<void>();
  final notifier = creator(0);
  final listenersList = <VoidCallback>[
    for (var i = 0; i < listeners - 1; i++) () {}
  ];

  for (final l in listenersList) {
    notifier.addListener(l);
  }

  final timer = Stopwatch();

  notifier.addListener(() {
    for (final l in listenersList) {
      notifier.removeListener(l);
    }
    timer.stop();
    c.complete();
  });

  timer.start();

  notifier.value = 1;

  await c.future;

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
              await runBenchmark(
                creator: entry.value,
                listeners: listeners,
              ),
            )
    ].calcAverages();

    printTestResults(results,
        header: "Remove Listeners while notify benchmark test",
        showUpdates: false);

    //delay to be sure the big table is printed before finishing so the table is printed as whole;
    await Future.delayed(Duration(seconds: 5));
  });
}
