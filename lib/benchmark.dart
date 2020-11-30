import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:getx_benchmark/notifiers/clever_value_notifier.dart';
import 'package:getx_benchmark/notifiers/custom_linked_list_value_notifier.dart';
import 'package:getx_benchmark/notifiers/linked_list_value_notifier.dart';
import 'package:getx_benchmark/notifiers/original_change_notifier.dart';
import 'package:getx_benchmark/notifiers/thomas2.dart';
import 'package:getx_benchmark/print_table.dart';
import 'package:getx_benchmark/testresult.dart';

typedef BenchMarkFunction = Future<int> Function({int updates, int listeners});

const _benchmarkRuns = 10;
const _listenersToTest = [1, 2, 4, 8, 16, 32];
const _updatesToTest = [10, 100, 1000, 10000, 100000];

const Map<String, BenchMarkFunction> _benchmarksMap = {
  "OriginalValueNotifier": originalValueNotifier,
  "ValueNotifier": defaultValueNotifier,
  "CleverValueNotifier": cleverValueNotifier,
  "Thomas2" : thomas2ValueNotifer,
  "CustomLinkedListValueNotifier": customLinkedListValueNotifier,
};

Future<int> originalValueNotifier({final int updates, final int listeners}) {
  final c = Completer<int>();
  final notifier = OriginalValueNotifier<int>(0);
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

Future<int> defaultValueNotifier({final int updates, final int listeners}) {
  final c = Completer<int>();
  final notifier = ValueNotifier<int>(0);
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

Future<int> linkedListValueNotifier({final int updates, final int listeners}) {
  final c = Completer<int>();
  final notifier = LinkedListValueNotifier<int>(0);
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

Future<int> customLinkedListValueNotifier(
    {final int updates, final int listeners}) {
  final c = Completer<int>();
  final notifier = CustomLinkedListChangeNotifier<int>(0);
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


Future<int> thomas2ValueNotifer(
    {final int updates, final int listeners}) {
  final c = Completer<int>();
  final notifier = Thomas2ValueNotifier<int>(0);
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



Future<int> cleverValueNotifier({final int updates, final int listeners}) {
  final c = Completer<int>();
  final notifier = CleverValueNotifier<int>(0);
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
    for (final f in _benchmarksMap.entries) {
      print("warmup ${f.key}");
      await f.value(updates: 10000, listeners: 10);
    }
  });

  test("benchmark", () async {
    final results = [
      for (var i = 0; i < _benchmarkRuns; i++)
        for (final entry in _benchmarksMap.entries)
          for (var listeners in _listenersToTest)
            for (var updates in _updatesToTest)
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

    printTestResults(results, updatesToTest: _updatesToTest);

    //delay to be sure the big table is printed before finishing so the table is printed as whole;
    await Future.delayed(Duration(seconds: 5));
  }, timeout: Timeout.none);
}
