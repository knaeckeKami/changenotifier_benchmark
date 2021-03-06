# value notifier benchmarks

This benchmark may help us in finding a faster implementation for ChangeNotifier.
See https://github.com/flutter/flutter/issues/71900 and https://github.com/flutter/flutter/pull/71986

The times have been measured on a OnePlus 8 Pro in release mode.

## Updates test

```
┌───────────────────────────────────────────────────────────────────────────────┐
│                            ValueNotifier benchmark                            │
├─────────────┬─────────────────────┬─────────────────────┬─────────────────────┤
│             │       Initial       │       Current       │      Proposed       │
│  Listeners  ├─────────┬───────────┼─────────┬───────────┼─────────┬───────────┤
│             │ Updates │ Time [µs] │ Updates │ Time [µs] │ Updates │ Time [µs] │
├─────────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┤
│             │      10 │         2 │      10 │         1 │      10 │         0 │
│             ├─────────┼───────────┼─────────┼───────────┼─────────┼───────────┤
│             │     100 │       114 │     100 │         1 │     100 │         1 │
│           1 ├─────────┼───────────┼─────────┼───────────┼─────────┼───────────┤
│             │    1000 │        82 │    1000 │        14 │    1000 │        12 │
│             ├─────────┼───────────┼─────────┼───────────┼─────────┼───────────┤
│             │   10000 │      1194 │   10000 │       162 │   10000 │       225 │
├─────────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┤
│             │      10 │         6 │      10 │         6 │      10 │         1 │
│             ├─────────┼───────────┼─────────┼───────────┼─────────┼───────────┤
│             │     100 │        26 │     100 │        14 │     100 │         2 │
│           2 ├─────────┼───────────┼─────────┼───────────┼─────────┼───────────┤
│             │    1000 │       266 │    1000 │       146 │    1000 │        22 │
│             ├─────────┼───────────┼─────────┼───────────┼─────────┼───────────┤
│             │   10000 │      3346 │   10000 │      1459 │   10000 │       255 │
├─────────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┤
│             │      10 │        18 │      10 │         3 │      10 │         1 │
│             ├─────────┼───────────┼─────────┼───────────┼─────────┼───────────┤
│             │     100 │        68 │     100 │        22 │     100 │         3 │
│           4 ├─────────┼───────────┼─────────┼───────────┼─────────┼───────────┤
│             │    1000 │       743 │    1000 │       209 │    1000 │        28 │
│             ├─────────┼───────────┼─────────┼───────────┼─────────┼───────────┤
│             │   10000 │      7556 │   10000 │      2240 │   10000 │       309 │
├─────────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┤
│             │      10 │        22 │      10 │         5 │      10 │         1 │
│             ├─────────┼───────────┼─────────┼───────────┼─────────┼───────────┤
│             │     100 │       153 │     100 │        37 │     100 │        56 │
│           8 ├─────────┼───────────┼─────────┼───────────┼─────────┼───────────┤
│             │    1000 │      1557 │    1000 │       372 │    1000 │        58 │
│             ├─────────┼───────────┼─────────┼───────────┼─────────┼───────────┤
│             │   10000 │     15599 │   10000 │      4559 │   10000 │       532 │
├─────────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┤
│             │      10 │        81 │      10 │         8 │      10 │         1 │
│             ├─────────┼───────────┼─────────┼───────────┼─────────┼───────────┤
│             │     100 │       320 │     100 │        68 │     100 │         9 │
│          16 ├─────────┼───────────┼─────────┼───────────┼─────────┼───────────┤
│             │    1000 │      3238 │    1000 │       939 │    1000 │        90 │
│             ├─────────┼───────────┼─────────┼───────────┼─────────┼───────────┤
│             │   10000 │     31379 │   10000 │      8216 │   10000 │      1041 │
├─────────────┼─────────┴───────────┼─────────┴───────────┼─────────┴───────────┤
│ Total Time: │               65770 │               18481 │                2647 │
└─────────────┴─────────────────────┴─────────────────────┴─────────────────────┘
```

## Remove Listeners test


```
┌─────────────────────────────────────────────────┐
│         Remove Listeners benchmark test         │
├─────────────┬───────────┬───────────┬───────────┤
│             │  Initial  │  Current  │ Proposed  │
│  Listeners  ├───────────┼───────────┼───────────┤
│             │ Time [µs] │ Time [µs] │ Time [µs] │
├─────────────┼───────────┼───────────┼───────────┤
│           1 │         0 │         2 │         0 │
├─────────────┼───────────┼───────────┼───────────┤
│           2 │         0 │         1 │         0 │
├─────────────┼───────────┼───────────┼───────────┤
│           4 │         4 │         0 │         0 │
├─────────────┼───────────┼───────────┼───────────┤
│           8 │         2 │         1 │         1 │
├─────────────┼───────────┼───────────┼───────────┤
│          16 │         4 │         3 │         3 │
├─────────────┼───────────┼───────────┼───────────┤
│ Total Time: │        10 │         7 │         4 │
└─────────────┴───────────┴───────────┴───────────┘
```

## Remove all listeners, while ValueNotifier is notifying*


```
┌─────────────────────────────────────────────────┐
│  Remove Listeners while notify benchmark test   │
├─────────────┬───────────┬───────────┬───────────┤
│             │  Initial  │  Current  │ Proposed  │
│  Listeners  ├───────────┼───────────┼───────────┤
│             │ Time [µs] │ Time [µs] │ Time [µs] │
├─────────────┼───────────┼───────────┼───────────┤
│           1 │         0 │         0 │         0 │
├─────────────┼───────────┼───────────┼───────────┤
│           2 │         1 │         0 │         0 │
├─────────────┼───────────┼───────────┼───────────┤
│           4 │         4 │         1 │         0 │
├─────────────┼───────────┼───────────┼───────────┤
│           8 │        17 │         1 │         1 │
├─────────────┼───────────┼───────────┼───────────┤
│          16 │        30 │         7 │         2 │
├─────────────┼───────────┼───────────┼───────────┤
│ Total Time: │        52 │         9 │         3 │
└─────────────┴───────────┴───────────┴───────────┘
```

*not supported by GetX

## Add listeners

```
┌─────────────────────────────────────────────────┐
│              addListener benchmark              │
├─────────────┬───────────┬───────────┬───────────┤
│             │  Initial  │  Current  │ Proposed  │
│  Listeners  ├───────────┼───────────┼───────────┤
│             │ Time [µs] │ Time [µs] │ Time [µs] │
├─────────────┼───────────┼───────────┼───────────┤
│           1 │         0 │         0 │         0 │
├─────────────┼───────────┼───────────┼───────────┤
│           2 │         0 │         0 │         1 │
├─────────────┼───────────┼───────────┼───────────┤
│           4 │         0 │         8 │         0 │
├─────────────┼───────────┼───────────┼───────────┤
│           8 │         0 │         8 │         0 │
├─────────────┼───────────┼───────────┼───────────┤
│          16 │         0 │         3 │         0 │
├─────────────┼───────────┼───────────┼───────────┤
│ Total Time: │         0 │        19 │         1 │
└─────────────┴───────────┴───────────┴───────────┘
 ```
