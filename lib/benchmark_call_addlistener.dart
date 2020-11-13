import 'dart:async';

import 'package:barbecue/barbecue.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:getx_benchmark/notifiers/clever_value_notifier.dart';
import 'package:getx_benchmark/notifiers/linked_list_value_notifier.dart';
import 'package:getx_benchmark/notifiers/original_change_notifier.dart';
import 'package:getx_benchmark/print_table.dart';

typedef BenchMarkFunction = Future<int> Function({int updates, int listeners});

const listenersToTest = [1, 2, 4, 8, 16, 32];
const updatesToTest = [10, 100, 1000, 10000, 100000];

final Map<String, BenchMarkFunction> _benchmarksMap = {
  "OriginalValueNotifier": originalValueNotifier,
  "ValueNotifier": defaultValueNotifier,
  "Value (GetX)": getXValueNotifier,
  "CleverValueNotifier": cleverValueNotifier,
  "LinkedListValueNotifier": linkedListValueNotifier,
};

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
      for (final entry in _benchmarksMap.entries)
        for (var listeners in listenersToTest)
          for (var updates in updatesToTest)
            TestResult(listeners, updates, entry.key,
                await entry.value(listeners: listeners, updates: updates))
    ];

    printTestResults(results, updatesToTest, header: "addListener benchmark");
    await Future.delayed(Duration(seconds: 5));
  });
}
