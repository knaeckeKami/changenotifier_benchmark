import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:getx_benchmark/notifiers/clever_value_notifier.dart';
import 'package:getx_benchmark/notifiers/custom_linked_list_value_notifier.dart';
import 'package:getx_benchmark/notifiers/linked_list_value_notifier.dart';
import 'package:getx_benchmark/notifiers/original_change_notifier.dart';
import 'package:getx_benchmark/print_table.dart';

typedef BenchMarkFunction = Future<int> Function({int listeners});

const listenersToTest = [1, 2, 4, 8, 16, 32, 64, 128];

final Map<String, BenchMarkFunction> _benchmarksMap = {
  "OriginalValueNotifier": originalValueNotifier,
  "ValueNotifier": defaultValueNotifier,
//  "Value (GetX)": getXValueNotifier, (not supported)
  "CleverValueNotifier": cleverValueNotifier,
  "LinkedListValueNotifier": linkedListValueNotifier,
  "CustomLinkedListValueNotifier": customLinkedListValueNotifier,
};

Future<int> originalValueNotifier({final int listeners}) async {
  final c = Completer<void>();
  final notifier = OriginalValueNotifier<int>(0);
  final listenersList = <VoidCallback>[
    for (var i = 0; i < listeners - 1; i++) () {}
  ];
  final timer = Stopwatch()..start();

  for (final l in listenersList) {
    notifier.addListener(l);
  }
  notifier.addListener(() {
    for (final l in listenersList) {
      notifier.removeListener(l);
    }
    timer.stop();
    c.complete();
  });

  notifier.value = 1;

  await c.future;

  return timer.elapsedMicroseconds;
}

Future<int> defaultValueNotifier({final int listeners}) async {
  final c = Completer<void>();
  final notifier = ValueNotifier<int>(0);
  final listenersList = <VoidCallback>[
    for (var i = 0; i < listeners - 1; i++) () {}
  ];
  final timer = Stopwatch()..start();

  for (final l in listenersList) {
    notifier.addListener(l);
  }
  notifier.addListener(() {
    for (final l in listenersList) {
      notifier.removeListener(l);
    }
    timer.stop();
    c.complete();
  });
  notifier.value = 1;

  await c.future;

  return timer.elapsedMicroseconds;
}

Future<int> linkedListValueNotifier({final int listeners}) async {
  final c = Completer<void>();
  final notifier = LinkedListValueNotifier<int>(0);
  final listenersList = <VoidCallback>[
    for (var i = 0; i < listeners - 1; i++) () {}
  ];
  final timer = Stopwatch()..start();

  for (final l in listenersList) {
    notifier.addListener(l);
  }
  notifier.addListener(() {
    for (final l in listenersList) {
      notifier.removeListener(l);
    }
    timer.stop();
    c.complete();
  });
  notifier.value = 1;

  await c.future;

  return timer.elapsedMicroseconds;
}

Future<int> customLinkedListValueNotifier({final int listeners}) async {
  final c = Completer<void>();
  final notifier = CustomLinkedListChangeNotifier<int>(0);
  final listenersList = <VoidCallback>[
    for (var i = 0; i < listeners - 1; i++) () {}
  ];
  final timer = Stopwatch()..start();

  for (final l in listenersList) {
    notifier.addListener(l);
  }
  notifier.addListener(() {
    for (final l in listenersList) {
      notifier.removeListener(l);
    }
    timer.stop();
    c.complete();
  });
  notifier.value = 1;

  await c.future;

  return timer.elapsedMicroseconds;
}

Future<int> cleverValueNotifier(
    {final int updates, final int listeners}) async {
  final c = Completer<void>();
  final notifier = CleverValueNotifier<int>(0);
  final listenersList = <VoidCallback>[
    for (var i = 0; i < listeners - 1; i++) () {}
  ];
  final timer = Stopwatch()..start();

  for (final l in listenersList) {
    notifier.addListener(l);
  }
  notifier.addListener(() {
    for (final l in listenersList) {
      notifier.removeListener(l);
    }
    timer.stop();
    c.complete();
  });
  notifier.value = 1;

  await c.future;

  return timer.elapsedMicroseconds;
}

Future<int> getXValueNotifier({final int listeners}) async {
  final c = Completer<void>();
  final notifier = Value<int>(0);
  final listenersList = <VoidCallback>[
    for (var i = 0; i < listeners - 1; i++) () {}
  ];
  final timer = Stopwatch()..start();

  for (final l in listenersList) {
    notifier.addListener(l);
  }
  notifier.addListener(() {
    for (final l in listenersList) {
      notifier.removeListener(l);
    }
    timer.stop();
    c.complete();
  });
  notifier.value = 1;

  await c.future;

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
              await entry.value(
                listeners: listeners,
              ))
    ];

    printTestResults(results,
        header: "Remove Listeners while notify benchmark test",
        showUpdates: false);

    //delay to be sure the big table is printed before finishing so the table is printed as whole;
    await Future.delayed(Duration(seconds: 5));
  });
}
