// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:getx_benchmark/notifiers/clever_value_notifier.dart';
import 'package:getx_benchmark/notifiers/original_change_notifier.dart';
import 'package:getx_benchmark/notifiers/thomas2.dart';

import 'common.dart';

const int _kNumIterations = 100000;
const double _scale = 1;
const int _kNumWarmUp = 100;

void main() {
  assert(false,
      "Don't run benchmarks in checked mode! Use 'flutter run --release'.");
  const ChangeNotifierBenchmark('Initial', _createInitialNotifier).run();
  const ChangeNotifierBenchmark('Current', _createCurrentNotifier).run();
  const ChangeNotifierBenchmark('Proposed', _createProposedNotifier).run();
}

class ChangeNotifierBenchmark {
  const ChangeNotifierBenchmark(
    this.name,
    this.notifierFactory,
  );

  final _Notifier Function() notifierFactory;
  final String name;

  void run() {
    void listener() {}
    void listener2() {}
    void listener3() {}
    void listener4() {}
    void listener5() {}

    // Warm up lap
    for (int i = 0; i < _kNumWarmUp; i += 1) {
      notifierFactory()
        ..addListener(listener)
        ..addListener(listener2)
        ..addListener(listener3)
        ..addListener(listener4)
        ..addListener(listener5)
        ..notify()
        ..removeListener(listener)
        ..removeListener(listener2)
        ..removeListener(listener3)
        ..removeListener(listener4)
        ..removeListener(listener5);
    }

    final Stopwatch addListenerWatch = Stopwatch();
    final Stopwatch removeListenerWatch = Stopwatch();
    final Stopwatch notifyListenersWatch = Stopwatch();
    final BenchmarkResultPrinter printer = BenchmarkResultPrinter();

    for (int listenersCount = 0; listenersCount <= 5; listenersCount++) {
      for (int j = 0; j < _kNumIterations; j += 1) {
        final _Notifier notifier = notifierFactory();
        addListenerWatch.start();

        notifier.addListener(listener);
        if (listenersCount > 1) notifier.addListener(listener2);
        if (listenersCount > 2) notifier.addListener(listener3);
        if (listenersCount > 3) notifier.addListener(listener4);
        if (listenersCount > 4) notifier.addListener(listener5);

        addListenerWatch.stop();
        notifyListenersWatch.start();

        notifier.notify();

        notifyListenersWatch.stop();
        removeListenerWatch.start();

        // Remove listeners in reverse order to evaluate the worse-case scenario:
        // the listener removed is the last listener
        if (listenersCount > 4) notifier.removeListener(listener5);
        if (listenersCount > 3) notifier.removeListener(listener4);
        if (listenersCount > 2) notifier.removeListener(listener3);
        if (listenersCount > 1) notifier.removeListener(listener2);
        notifier.removeListener(listener);

        removeListenerWatch.stop();
      }

      final int notifyListener = notifyListenersWatch.elapsedMicroseconds;
      notifyListenersWatch.reset();
      final int addListenerElapsed = addListenerWatch.elapsedMicroseconds;
      addListenerWatch.reset();
      final int removeListenerElapsed = removeListenerWatch.elapsedMicroseconds;
      removeListenerWatch.reset();

      printer.addResult(
        description: '$name.addListener ($listenersCount listeners)',
        value: addListenerElapsed * _scale,
        unit: 'ns per iteration',
        name: '$name.addListener${listenersCount}_iteration',
      );

      printer.addResult(
        description: '$name.removeListener ($listenersCount listeners)',
        value: removeListenerElapsed * _scale,
        unit: 'ns per iteration',
        name: '$name.removeListener${listenersCount}_iteration',
      );

      printer.addResult(
        description: '$name.notifyListener ($listenersCount listeners)',
        value: notifyListener * _scale,
        unit: 'ns per iteration',
        name: '$name.notifyListener${listenersCount}_iteration',
      );
    }

    printer.printToStdout();
  }
}

abstract class _Notifier implements Listenable {
  void notify();
}

class _InitialNotifier extends OriginalChangeNotifier implements _Notifier {
  void notify() => notifyListeners();
}

class _CurrentNotifier extends ChangeNotifier implements _Notifier {
  void notify() => notifyListeners();
}

class _ProposedNotifier extends CleverChangeNotifier implements _Notifier {
  void notify() => notifyListeners();
}

class _Thomas2Notifier extends Thomas2ChangeNotifier implements _Notifier {
  void notify() => notifyListeners();
}

_Notifier _createInitialNotifier() => _InitialNotifier();
_Notifier _createCurrentNotifier() => _CurrentNotifier();
_Notifier _createProposedNotifier() => _ProposedNotifier();
_Notifier _createThomas2Notifier() => _Thomas2Notifier();
