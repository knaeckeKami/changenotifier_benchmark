# value notifier benchmarks

This benchmark may help us in finding a faster implementation for ChangeNotifier.

The times have been measured on my Huawei Mate 20 Pro in release mode.

## Updates test

```
 ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
 │                                                                   ValueNotifier benchmark                                                                    │
 ├─────────────┬──────────────────────┬─────────────────────┬─────────────────────┬─────────────────────┬────────────────────────┬──────────────────────────────┤
 │             │ OriginalValueNotifier│    ValueNotifier    │    Value (GetX)     │ CleverValueNotifier │ LinkedListValueNotifier│ CustomLinkedListValueNotifier│
 │  Listeners  ├──────────┬───────────┼─────────┬───────────┼─────────┬───────────┼─────────┬───────────┼───────────┬────────────┼──────────────┬───────────────┤
 │             │ Updates  │ Time [µs] │ Updates │ Time [µs] │ Updates │ Time [µs] │ Updates │ Time [µs] │  Updates  │ Time [µs]  │   Updates    │   Time [µs]   │
 ├─────────────┼──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │             │       10 │        21 │      10 │         5 │      10 │         2 │      10 │         2 │        10 │          4 │           10 │             2 │
 │             ├──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │             │      100 │        40 │     100 │        16 │     100 │         4 │     100 │         2 │       100 │          8 │          100 │             4 │
 │             ├──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │           1 │     1000 │       403 │    1000 │       152 │    1000 │        34 │    1000 │        24 │      1000 │         83 │         1000 │            38 │
 │             ├──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │             │    10000 │      4744 │   10000 │      1480 │   10000 │       347 │   10000 │       239 │     10000 │        831 │        10000 │           372 │
 │             ├──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │             │   100000 │     42706 │  100000 │     14999 │  100000 │      3394 │  100000 │      2416 │    100000 │       8619 │       100000 │          3723 │
 ├─────────────┼──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │             │       10 │        15 │      10 │         5 │      10 │         2 │      10 │         1 │        10 │         23 │           10 │             2 │
 │             ├──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │             │      100 │        94 │     100 │        19 │     100 │         5 │     100 │         4 │       100 │         11 │          100 │             6 │
 │             ├──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │           2 │     1000 │      1075 │    1000 │       194 │    1000 │        43 │    1000 │        35 │      1000 │        113 │         1000 │            61 │
 │             ├──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │             │    10000 │     10179 │   10000 │      1869 │   10000 │       439 │   10000 │       351 │     10000 │       1242 │        10000 │           597 │
 │             ├──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │             │   100000 │     81322 │  100000 │     19544 │  100000 │      4486 │  100000 │      3520 │    100000 │      11484 │       100000 │          5999 │
 ├─────────────┼──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │             │       10 │        24 │      10 │         6 │      10 │         2 │      10 │         1 │        10 │          5 │           10 │             2 │
 │             ├──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │             │      100 │       104 │     100 │        29 │     100 │         6 │     100 │         6 │       100 │         18 │          100 │            11 │
 │             ├──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │           4 │     1000 │      1111 │    1000 │       301 │    1000 │        63 │    1000 │        56 │      1000 │        174 │         1000 │           105 │
 │             ├──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │             │    10000 │     13799 │   10000 │      2973 │   10000 │       638 │   10000 │       560 │     10000 │       1720 │        10000 │          1058 │
 │             ├──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │             │   100000 │    108259 │  100000 │     29950 │  100000 │      6261 │  100000 │      5684 │    100000 │      17566 │       100000 │         10576 │
 ├─────────────┼──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │             │       10 │        35 │      10 │         9 │      10 │         3 │      10 │         2 │        10 │          6 │           10 │             3 │
 │             ├──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │             │      100 │       220 │     100 │        56 │     100 │        13 │     100 │        11 │       100 │         34 │          100 │            22 │
 │             ├──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │           8 │     1000 │      1918 │    1000 │       557 │    1000 │       119 │    1000 │       173 │      1000 │        447 │         1000 │           233 │
 │             ├──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │             │    10000 │     22700 │   10000 │      5475 │   10000 │      1201 │   10000 │      1213 │     10000 │       3321 │        10000 │          2313 │
 │             ├──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │             │   100000 │    175309 │  100000 │     55522 │  100000 │     11949 │  100000 │     11974 │    100000 │      34403 │       100000 │         23025 │
 ├─────────────┼──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │             │       10 │        56 │      10 │        13 │      10 │         3 │      10 │         3 │        10 │          9 │           10 │             5 │
 │             ├──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │             │      100 │       390 │     100 │        97 │     100 │        20 │     100 │        21 │       100 │         60 │          100 │            40 │
 │             ├──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │          16 │     1000 │      3460 │    1000 │       990 │    1000 │       197 │    1000 │       207 │      1000 │        593 │         1000 │           424 │
 │             ├──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │             │    10000 │     34789 │   10000 │      9950 │   10000 │      1969 │   10000 │      2058 │     10000 │       6196 │        10000 │          4222 │
 │             ├──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │             │   100000 │    382509 │  100000 │     99804 │  100000 │     20298 │  100000 │     20493 │    100000 │      64120 │       100000 │         46985 │
 ├─────────────┼──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │             │       10 │       105 │      10 │        22 │      10 │         6 │      10 │         5 │        10 │         17 │           10 │            10 │
 │             ├──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │             │      100 │       711 │     100 │       181 │     100 │        36 │     100 │        39 │       100 │        116 │          100 │            78 │
 │             ├──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │          32 │     1000 │      7374 │    1000 │      1811 │    1000 │       354 │    1000 │       379 │      1000 │       1100 │         1000 │           790 │
 │             ├──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │             │    10000 │     66349 │   10000 │     18395 │   10000 │      3520 │   10000 │      3831 │     10000 │      11015 │        10000 │          7811 │
 │             ├──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │             │   100000 │    737905 │  100000 │    185973 │  100000 │     35573 │  100000 │     37612 │    100000 │     121577 │       100000 │         77044 │
 ├─────────────┼──────────┴───────────┼─────────┴───────────┼─────────┴───────────┼─────────┴───────────┼───────────┴────────────┼──────────────┴───────────────┤
 │ Total Time: │              1697726 │              450397 │               90987 │               90922 │                 284915 │                       185561 │
 └─────────────┴──────────────────────┴─────────────────────┴─────────────────────┴─────────────────────┴────────────────────────┴──────────────────────────────┘
```

## Remove Listeners test


```
 ┌────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
 │                                              Remove Listeners benchmark test                                               │
 ├─────────────┬───────────────┬──────────────┬─────────────────────┬─────────────────────────┬───────────────────────────────┤
 │             │ ValueNotifier │ Value (GetX) │ CleverValueNotifier │ LinkedListValueNotifier │ CustomLinkedListValueNotifier │
 │  Listeners  ├───────────────┼──────────────┼─────────────────────┼─────────────────────────┼───────────────────────────────┤
 │             │   Time [µs]   │  Time [µs]   │      Time [µs]      │        Time [µs]        │           Time [µs]           │
 ├─────────────┼───────────────┼──────────────┼─────────────────────┼─────────────────────────┼───────────────────────────────┤
 │           1 │             2 │            1 │                   1 │                       4 │                             2 │
 ├─────────────┼───────────────┼──────────────┼─────────────────────┼─────────────────────────┼───────────────────────────────┤
 │           2 │             1 │            0 │                   1 │                       1 │                             1 │
 ├─────────────┼───────────────┼──────────────┼─────────────────────┼─────────────────────────┼───────────────────────────────┤
 │           4 │             3 │            1 │                   1 │                       1 │                             1 │
 ├─────────────┼───────────────┼──────────────┼─────────────────────┼─────────────────────────┼───────────────────────────────┤
 │           8 │             2 │            2 │                   2 │                       2 │                             2 │
 ├─────────────┼───────────────┼──────────────┼─────────────────────┼─────────────────────────┼───────────────────────────────┤
 │          16 │             6 │            4 │                   4 │                       4 │                             4 │
 ├─────────────┼───────────────┼──────────────┼─────────────────────┼─────────────────────────┼───────────────────────────────┤
 │          32 │            10 │           10 │                  10 │                       9 │                             7 │
 ├─────────────┼───────────────┼──────────────┼─────────────────────┼─────────────────────────┼───────────────────────────────┤
 │         128 │            43 │           92 │                  75 │                      38 │                            33 │
 ├─────────────┼───────────────┼──────────────┼─────────────────────┼─────────────────────────┼───────────────────────────────┤
 │        1024 │           350 │         2471 │                2493 │                     316 │                           264 │
 ├─────────────┼───────────────┼──────────────┼─────────────────────┼─────────────────────────┼───────────────────────────────┤
 │ Total Time: │           417 │         2581 │                2587 │                     375 │                           314 │
 └─────────────┴───────────────┴──────────────┴─────────────────────┴─────────────────────────┴───────────────────────────────┘
 ```

## Remove all listeners, while ValueNotifier is notifying*


```
 ┌─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
 │                                            Remove Listeners while notify benchmark test                                             │
 ├─────────────┬───────────────────────┬───────────────┬─────────────────────┬─────────────────────────┬───────────────────────────────┤
 │             │ OriginalValueNotifier │ ValueNotifier │ CleverValueNotifier │ LinkedListValueNotifier │ CustomLinkedListValueNotifier │
 │  Listeners  ├───────────────────────┼───────────────┼─────────────────────┼─────────────────────────┼───────────────────────────────┤
 │             │       Time [µs]       │   Time [µs]   │      Time [µs]      │        Time [µs]        │           Time [µs]           │
 ├─────────────┼───────────────────────┼───────────────┼─────────────────────┼─────────────────────────┼───────────────────────────────┤
 │           1 │                    15 │             3 │                   1 │                       2 │                             1 │
 ├─────────────┼───────────────────────┼───────────────┼─────────────────────┼─────────────────────────┼───────────────────────────────┤
 │           2 │                     5 │             5 │                   1 │                       2 │                             1 │
 ├─────────────┼───────────────────────┼───────────────┼─────────────────────┼─────────────────────────┼───────────────────────────────┤
 │           4 │                    13 │             2 │                   3 │                       1 │                             2 │
 ├─────────────┼───────────────────────┼───────────────┼─────────────────────┼─────────────────────────┼───────────────────────────────┤
 │           8 │                    15 │             3 │                   7 │                       2 │                             2 │
 ├─────────────┼───────────────────────┼───────────────┼─────────────────────┼─────────────────────────┼───────────────────────────────┤
 │          16 │                    28 │             6 │                  27 │                       4 │                             3 │
 ├─────────────┼───────────────────────┼───────────────┼─────────────────────┼─────────────────────────┼───────────────────────────────┤
 │          32 │                    84 │            14 │                  94 │                       9 │                             8 │
 ├─────────────┼───────────────────────┼───────────────┼─────────────────────┼─────────────────────────┼───────────────────────────────┤
 │          64 │                   122 │            33 │                 368 │                      18 │                            15 │
 ├─────────────┼───────────────────────┼───────────────┼─────────────────────┼─────────────────────────┼───────────────────────────────┤
 │         128 │                   247 │            58 │                1806 │                      36 │                            34 │
 ├─────────────┼───────────────────────┼───────────────┼─────────────────────┼─────────────────────────┼───────────────────────────────┤
 │ Total Time: │                   529 │           124 │                2307 │                      74 │                            66 │
 └─────────────┴───────────────────────┴───────────────┴─────────────────────┴─────────────────────────┴───────────────────────────────┘
```

*not supported by GetX

## Add listeners

```
 ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
 │                                                                    addListener benchmark                                                                     │
 ├─────────────┬──────────────────────┬─────────────────────┬─────────────────────┬─────────────────────┬────────────────────────┬──────────────────────────────┤
 │             │ OriginalValueNotifier│    ValueNotifier    │    Value (GetX)     │ CleverValueNotifier │ LinkedListValueNotifier│ CustomLinkedListValueNotifier│
 │  Listeners  ├──────────┬───────────┼─────────┬───────────┼─────────┬───────────┼─────────┬───────────┼───────────┬────────────┼──────────────┬───────────────┤
 │             │ Updates  │ Time [µs] │ Updates │ Time [µs] │ Updates │ Time [µs] │ Updates │ Time [µs] │  Updates  │ Time [µs]  │   Updates    │   Time [µs]   │
 ├─────────────┼──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │             │       10 │         1 │      10 │         0 │      10 │         1 │      10 │         0 │        10 │          0 │           10 │             0 │
 │             ├──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │             │      100 │         1 │     100 │         1 │     100 │         0 │     100 │         0 │       100 │          0 │          100 │             0 │
 │             ├──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │           1 │     1000 │         0 │    1000 │         0 │    1000 │         0 │    1000 │         0 │      1000 │          0 │         1000 │             0 │
 │             ├──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │             │    10000 │         0 │   10000 │         0 │   10000 │         0 │   10000 │         0 │     10000 │          1 │        10000 │             0 │
 │             ├──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │             │   100000 │         1 │  100000 │         0 │  100000 │         0 │  100000 │         0 │    100000 │          0 │       100000 │             1 │
 ├─────────────┼──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │             │       10 │         2 │      10 │         4 │      10 │         2 │      10 │         1 │        10 │          5 │           10 │             1 │
 │             ├──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │             │      100 │         1 │     100 │         1 │     100 │         1 │     100 │         1 │       100 │          2 │          100 │             1 │
 │             ├──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │           2 │     1000 │         1 │    1000 │         1 │    1000 │         1 │    1000 │         1 │      1000 │          1 │         1000 │             1 │
 │             ├──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │             │    10000 │         1 │   10000 │         1 │   10000 │         1 │   10000 │         0 │     10000 │          2 │        10000 │             1 │
 │             ├──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │             │   100000 │         1 │  100000 │         8 │  100000 │         1 │  100000 │         1 │    100000 │          1 │       100000 │             1 │
 ├─────────────┼──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │             │       10 │         1 │      10 │         3 │      10 │         1 │      10 │         1 │        10 │          3 │           10 │             2 │
 │             ├──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │             │      100 │         1 │     100 │         2 │     100 │         1 │     100 │         1 │       100 │          2 │          100 │             1 │
 │             ├──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │           4 │     1000 │         1 │    1000 │         1 │    1000 │         1 │    1000 │         1 │      1000 │          2 │         1000 │             2 │
 │             ├──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │             │    10000 │         1 │   10000 │         2 │   10000 │         1 │   10000 │         1 │     10000 │          2 │        10000 │             1 │
 │             ├──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │             │   100000 │         1 │  100000 │         2 │  100000 │         1 │  100000 │         1 │    100000 │          6 │       100000 │             1 │
 ├─────────────┼──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │             │       10 │         2 │      10 │         3 │      10 │         8 │      10 │         5 │        10 │          3 │           10 │             2 │
 │             ├──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │             │      100 │         2 │     100 │         3 │     100 │         2 │     100 │         1 │       100 │          3 │          100 │             2 │
 │             ├──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │           8 │     1000 │         2 │    1000 │        12 │    1000 │         1 │    1000 │         1 │      1000 │          3 │         1000 │             2 │
 │             ├──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │             │    10000 │         5 │   10000 │         3 │   10000 │         2 │   10000 │         5 │     10000 │          3 │        10000 │             5 │
 │             ├──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │             │   100000 │         2 │  100000 │         3 │  100000 │         5 │  100000 │         1 │    100000 │          3 │       100000 │             2 │
 ├─────────────┼──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │             │       10 │         3 │      10 │         5 │      10 │         6 │      10 │         2 │        10 │          6 │           10 │             3 │
 │             ├──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │             │      100 │         3 │     100 │         8 │     100 │         6 │     100 │         2 │       100 │          5 │          100 │             3 │
 │             ├──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │          16 │     1000 │         6 │    1000 │         8 │    1000 │         6 │    1000 │         2 │      1000 │          9 │         1000 │             3 │
 │             ├──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │             │    10000 │         6 │   10000 │         8 │   10000 │         6 │   10000 │         2 │     10000 │         10 │        10000 │             3 │
 │             ├──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │             │   100000 │         3 │  100000 │         9 │  100000 │        10 │  100000 │         2 │    100000 │          9 │       100000 │             6 │
 ├─────────────┼──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │             │       10 │         8 │      10 │        12 │      10 │         7 │      10 │         6 │        10 │         14 │           10 │             8 │
 │             ├──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │             │      100 │         8 │     100 │         9 │     100 │         7 │     100 │         5 │       100 │         10 │          100 │             7 │
 │             ├──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │          32 │     1000 │        10 │    1000 │        12 │    1000 │         7 │    1000 │         7 │      1000 │         14 │         1000 │             8 │
 │             ├──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │             │    10000 │         9 │   10000 │        12 │   10000 │        10 │   10000 │         3 │     10000 │         14 │        10000 │             5 │
 │             ├──────────┼───────────┼─────────┼───────────┼─────────┼───────────┼─────────┼───────────┼───────────┼────────────┼──────────────┼───────────────┤
 │             │   100000 │         8 │  100000 │         9 │  100000 │         6 │  100000 │        12 │    100000 │         13 │       100000 │            10 │
 ├─────────────┼──────────┴───────────┼─────────┴───────────┼─────────┴───────────┼─────────┴───────────┼───────────┴────────────┼──────────────┴───────────────┤
 │ Total Time: │                   91 │                 142 │                 101 │                  65 │                    146 │                           82 │
 └─────────────┴──────────────────────┴─────────────────────┴─────────────────────┴─────────────────────┴────────────────────────┴──────────────────────────────┘
```