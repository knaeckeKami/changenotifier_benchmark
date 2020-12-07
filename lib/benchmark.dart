import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:getx_benchmark/notifiers/factories.dart';
import 'package:getx_benchmark/print_table.dart';
import 'package:getx_benchmark/testresult.dart';

const _benchmarkRuns = 200;
const _listenersToTest = [1, 2, 4, 8, 16];
const _updatesToTest = [10, 100, 1000, 10000];

Future<int> runBenchmark({
  required ValueNotifierFactory creator,
  required final int updates,
  required final int listeners,
}) {
  final c = Completer<int>();
  final notifier = creator(0);
  final timer = Stopwatch()..start();

  for (var i = 0; i < listeners - 1; i++) {
    notifier.addListener(() {});
  }
  notifier.addListener(() {
    if (updates == notifier.value) {
      timer.stop();
      c.complete(timer.elapsedMicroseconds);
    }
  });

  for (var i = 0; i <= updates; i++) {
    notifier.value = i;
  }
  return c.future;
}

void main() {
  setUpAll(() async {
    for (final f in factories.entries) {
      print("warmup ${f.key}");
      await runBenchmark(creator: f.value, updates: 10000, listeners: 10);
    }
  });

  test("benchmark", () async {
    final results = [
      for (var i = 0; i < _benchmarkRuns; i++)
        for (final entry in factories.entries)
          for (var listeners in _listenersToTest)
            for (var updates in _updatesToTest)
              TestResult(
                listeners,
                updates,
                entry.key,
                await runBenchmark(
                  creator: entry.value,
                  listeners: listeners,
                  updates: updates,
                ),
              )
    ].calcAverages();

    printTestResults(results, updatesToTest: _updatesToTest);

    //delay to be sure the big table is printed before finishing so the table is printed as whole;
    await Future.delayed(Duration(seconds: 5));
  }, timeout: Timeout.none);
}
