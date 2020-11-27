import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:getx_benchmark/notifiers/clever_value_notifier.dart';
import 'package:getx_benchmark/notifiers/custom_linked_list_value_notifier.dart';
import 'package:getx_benchmark/notifiers/linked_list_value_notifier.dart';
import 'package:getx_benchmark/notifiers/original_change_notifier.dart';
import 'package:getx_benchmark/notifiers/thomas2.dart';
import 'package:getx_benchmark/print_table.dart';
import 'package:getx_benchmark/testresult.dart';

typedef BenchMarkFunction = Future<int> Function({int updates, int listeners});

const _benchmarkRuns = 5000;
const listenersToTest = [1, 2, 4, 8, 16, 32, 64, 128];
const updatesToTest = [0];

final Map<String, BenchMarkFunction> _benchmarksMap = {
  "OriginalValueNotifier": originalValueNotifier,
  "ValueNotifier": defaultValueNotifier,
  "Value (GetX)": getXValueNotifier,
  "CleverValueNotifier": cleverValueNotifier,
  "Thomas2": thomas2,
  "LinkedListValueNotifier": linkedListValueNotifier,
  "CustomLinkedListValueNotifier": customLinkedListValueNotifier
};

Future<int> thomas2({final int updates, final int listeners}) {
  final c = Completer<int>();
  final notifier = Thomas2ValueNotifier(0);
  final timer = Stopwatch()..start();

  for (var i = 0; i < listeners - 1; i++) {
    notifier.addListener(() {});
  }
  timer.stop();
  c.complete(timer.elapsedMicroseconds);

  return c.future;
}

Future<int> linkedListValueNotifier({final int updates, final int listeners}) {
  final c = Completer<int>();
  final notifier = LinkedListValueNotifier(0);
  final timer = Stopwatch()..start();

  for (var i = 0; i < listeners - 1; i++) {
    notifier.addListener(() {});
  }
  timer.stop();
  c.complete(timer.elapsedMicroseconds);

  return c.future;
}

Future<int> customLinkedListValueNotifier(
    {final int updates, final int listeners}) {
  final c = Completer<int>();
  final notifier = CustomLinkedListChangeNotifier(0);
  final timer = Stopwatch()..start();

  for (var i = 0; i < listeners - 1; i++) {
    notifier.addListener(() {});
  }
  timer.stop();
  c.complete(timer.elapsedMicroseconds);

  return c.future;
}

Future<int> originalValueNotifier({final int updates, final int listeners}) {
  final c = Completer<int>();
  final notifier = OriginalValueNotifier(0);
  final timer = Stopwatch()..start();

  for (var i = 0; i < listeners - 1; i++) {
    notifier.addListener(() {});
  }
  timer.stop();
  c.complete(timer.elapsedMicroseconds);

  return c.future;
}

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
    for (final f in _benchmarksMap.entries) {
      print("warmup ${f.key}");
      await f.value(updates: 10000, listeners: 10);
    }
  });

  test("benchmark", () async {
    final results = [
      for (var i = 0; i < _benchmarkRuns; i++)
        for (final entry in _benchmarksMap.entries)
          for (var listeners in listenersToTest)
            for (var updates in updatesToTest)
              TestResult(
                listeners,
                updates,
                entry.key,
                await entry.value(
                  listeners: listeners,
                  updates: updates,
                ),
              )
    ].calcAverages();

    printTestResults(
      results,
      header: "addListener benchmark",
      updatesToTest: updatesToTest,
      showUpdates: false,
    );
    await Future.delayed(Duration(seconds: 1));
  });
}
