import 'package:flutter/material.dart';
import 'package:getx_benchmark/notifiers/initial.dart';
import 'package:getx_benchmark/notifiers/proposed.dart';

typedef ValueNotifierFactory = ValueNotifier<int> Function(int value);

final Map<String, ValueNotifierFactory> factories = {
  "Initial": (value) => InitialValueNotifier(value),
  "Current": (value) => ValueNotifier(value),
  "Proposed": (value) => ProposedValueNotifier(value),
};
