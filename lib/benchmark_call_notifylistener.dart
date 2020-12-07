import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:getx_benchmark/notifiers/factories.dart';
import 'package:getx_benchmark/print_table.dart';
import 'package:getx_benchmark/testresult.dart';

const _benchmarkRuns = 200;
const listenersToTest = [1, 2, 4, 8, 16];
const updatesToTest = [10, 100, 1000, 10000];

Future<int> runBenchmark({
  required ValueNotifierFactory creator,
  final int? updates,
  final int? listeners,
}) {
  final c = Completer<int>();
  final notifier = creator(0);
  final timer = Stopwatch()..start();

  for (var i = 0; i < listeners! - 1; i++) {
    notifier.addListener(() {});
  }
  for (var i = 0; i <= updates!; i++) {
    notifier.value = i;
  }
  timer.stop();
  c.complete(timer.elapsedMicroseconds);

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
          for (var listeners in listenersToTest)
            for (var updates in updatesToTest)
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

    printTestResults(results, updatesToTest: updatesToTest);

    await Future.delayed(Duration(seconds: 5));
  });
}
