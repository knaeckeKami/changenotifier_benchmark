import 'package:flutter/material.dart';
import 'package:getx_benchmark/notifiers/factories.dart';

const name = 'Proposed';
const notifierCount = 0;
const listenerCount = 1000;

main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final List<ValueNotifier<int>> notifiers;

  @override
  void initState() {
    super.initState();
    notifiers = List.generate(notifierCount, (index) {
      final notifier = factories[name]!(0);
      for (var i = 0; i < listenerCount; i++) {
        notifier.addListener(() {});
      }
      return notifier;
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
