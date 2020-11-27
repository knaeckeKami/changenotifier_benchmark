import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:getx_benchmark/notifiers/clever_value_notifier.dart';
import 'package:getx_benchmark/notifiers/custom_linked_list_value_notifier.dart';
import 'package:getx_benchmark/notifiers/linked_list_value_notifier.dart';
import 'package:getx_benchmark/notifiers/original_change_notifier.dart';
import 'package:getx_benchmark/print_table.dart';

import 'notifiers/thomas2.dart';

typedef BenchMarkFunction = int Function({int listeners});

const listenersToTest = [1, 2, 4, 8, 16, 32, 128, 1024];

final Map<String, BenchMarkFunction> _benchmarksMap = {
  "ValueNotifier": defaultValueNotifier,
  "Value (GetX)": getXValueNotifier,
  "CleverValueNotifier": cleverValueNotifier,
  "LinkedListValueNotifier": linkedListValueNotifier,
  "Thomas2": thomas2,
  "CustomLinkedListValueNotifier": customLinkedListValueNotifier,
};

int thomas2({final int listeners}) {
  final notifier = Thomas2ValueNotifier<int>(0);
  final listenersList = <VoidCallback>[
    for (var i = 0; i < listeners; i++) () {}
  ];
  final timer = Stopwatch()..start();

  for (var i = 0; i < listeners; i++) {
    notifier.addListener(listenersList[i]);
  }
  for (var i = 0; i < listeners; i++) {
    notifier.removeListener(listenersList[i]);
  }
  timer.stop();

  return timer.elapsedMicroseconds;
}

int originalValueNotifier({final int listeners}) {
  final notifier = OriginalValueNotifier<int>(0);
  final listenersList = <VoidCallback>[
    for (var i = 0; i < listeners; i++) () {}
  ];
  final timer = Stopwatch()..start();

  for (var i = 0; i < listeners; i++) {
    notifier.addListener(listenersList[i]);
  }
  for (var i = 0; i < listeners; i++) {
    notifier.removeListener(listenersList[i]);
  }
  timer.stop();

  return timer.elapsedMicroseconds;
}

int defaultValueNotifier({final int updates, final int listeners}) {
  final notifier = ValueNotifier<int>(0);
  final listenersList = <VoidCallback>[
    for (var i = 0; i < listeners; i++) () {}
  ];
  final timer = Stopwatch()..start();

  for (var i = 0; i < listeners; i++) {
    notifier.addListener(listenersList[i]);
  }
  for (var i = 0; i < listeners; i++) {
    notifier.removeListener(listenersList[i]);
  }
  timer.stop();

  return timer.elapsedMicroseconds;
}

int linkedListValueNotifier({final int updates, final int listeners}) {
  final notifier = LinkedListValueNotifier<int>(0);
  final listenersList = <VoidCallback>[
    for (var i = 0; i < listeners; i++) () {}
  ];
  final timer = Stopwatch()..start();

  for (var i = 0; i < listeners; i++) {
    notifier.addListener(listenersList[i]);
  }
  for (var i = 0; i < listeners; i++) {
    notifier.removeListener(listenersList[i]);
  }
  timer.stop();

  return timer.elapsedMicroseconds;
}

int customLinkedListValueNotifier({final int updates, final int listeners}) {
  final notifier = CustomLinkedListChangeNotifier<int>(0);
  final listenersList = <VoidCallback>[
    for (var i = 0; i < listeners; i++) () {}
  ];
  final timer = Stopwatch()..start();

  for (var i = 0; i < listeners; i++) {
    notifier.addListener(listenersList[i]);
  }
  for (var i = 0; i < listeners; i++) {
    notifier.removeListener(listenersList[i]);
  }
  timer.stop();

  return timer.elapsedMicroseconds;
}

int cleverValueNotifier({final int updates, final int listeners}) {
  final notifier = CleverValueNotifier<int>(0);
  final listenersList = <VoidCallback>[
    for (var i = 0; i < listeners; i++) () {}
  ];
  final timer = Stopwatch()..start();

  for (var i = 0; i < listeners; i++) {
    notifier.addListener(listenersList[i]);
  }
  for (var i = 0; i < listeners; i++) {
    notifier.removeListener(listenersList[i]);
  }
  timer.stop();

  return timer.elapsedMicroseconds;
}

int getXValueNotifier({final int updates, final int listeners}) {
  final notifier = Value<int>(0);
  final listenersList = <VoidCallback>[
    for (var i = 0; i < listeners; i++) () {}
  ];
  final timer = Stopwatch()..start();

  for (var i = 0; i < listeners; i++) {
    notifier.addListener(listenersList[i]);
  }
  for (var i = 0; i < listeners; i++) {
    notifier.removeListener(listenersList[i]);
  }
  timer.stop();

  return timer.elapsedMicroseconds;
}

void main() {
  setUpAll(() async {
    for (final f in _benchmarksMap.entries) {
      print("warmup ${f.key}");
      f.value(listeners: 100);
    }
  });

  test("benchmark", () async {
    final results = [
      for (final entry in _benchmarksMap.entries)
        for (var listeners in listenersToTest)
          TestResult(
              listeners,
              0,
              entry.key,
              entry.value(
                listeners: listeners,
              ))
    ];

    printTestResults(results,
        header: "Remove Listeners benchmark test", showUpdates: false);

    //delay to be sure the big table is printed before finishing so the table is printed as whole;
    await Future.delayed(Duration(seconds: 5));
  });
}
