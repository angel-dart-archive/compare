# Blank Response
Each server should return a blank response, or a response with no
request handlers run. This is the "base" request, and will probably be the
best-performing across all servers.

It is expected that the server sends a `Content-Type: application/json` header as well.

# Results
Average latency as server load (active connections) increases:
| Server               | 100    | 200    | 500    | 1k     | 2.5k   | 5k     | 10k    | Average Latency (ms)
| ---                  | ---    | ---    | ---    | ---    | ---    | ---    | ---    | ---
| Angel                | 62.81  | 38.01  | 33.15  | 32.94  | 31.92  | 33.60  |        | 38.74
| Angel (multiserver)  |        |        |        |        |        |        |        |
| Aqueduct             |        |        |        |        |        |        |        |
| `shelf`              |        |        |        |        |        |        |        |
| `dart:io`            | 12.93  | 38.27  | 29.05  | 22.25  | 18.30  | 18.53  | 11.35  | 21.53
| ExpressJS            | 159.12 | 157.17 | 95.84  | 61.48  | 23.78  | 20.21  |        | 86.27

Connections per second:
| Server              | Min. Conns./sec. | Max. Conns./sec. | Average Conns./sec.
| ---                 | ---              | ---              | ---
| Angel               | 5808.59          | 7085.14          | 6600.23
| Angel (multiserver) | 0                | 0                | 0
| Aqueduct            | 0                | 0                | 0
| `shelf`             | 0                | 0                | 0
| `dart:io`           | 11501.56         | 19196.21         | 13938.24
| ExpressJS           | 9004.47          | 11257.02         | 10491.69

## Data

100 connections:
```bash
wrk -c 100 -t 25 -d 60 http://localhost:3000
```

*Angel*:
```
Running 1m test @ http://localhost:3000
  25 threads and 100 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    62.81ms  141.31ms   1.99s    91.37%
    Req/Sec   263.34    246.69     4.07k    89.12%
  364804 requests in 1.00m, 65.75MB read
  Socket errors: connect 0, read 0, write 0, timeout 10
Requests/sec:   6069.98
Transfer/sec:      1.09MB
```

*`dart:io`*
```
  25 threads and 100 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    12.93ms   21.20ms 248.78ms   87.84%
    Req/Sec   727.35    541.68     7.84k    86.16%
  1082355 requests in 1.00m, 179.61MB read
Requests/sec:  18009.30
Transfer/sec:      2.99MB
```

*ExpressJS*:
```
Running 1m test @ http://localhost:3000
  25 threads and 100 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency   159.12ms  227.36ms   1.31s    81.71%
    Req/Sec   503.88    563.56     5.49k    86.68%
  624632 requests in 1.00m, 231.13MB read
  Non-2xx or 3xx responses: 624632
Requests/sec:  10393.20
Transfer/sec:      3.85MB
```

200 connections:
```bash
wrk -c 200 -t 25 -d 60 http://localhost:3000
```

*Angel*:
```
Running 1m test @ http://localhost:3000
  25 threads and 200 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    38.01ms   46.75ms   1.21s    97.05%
    Req/Sec   236.28     65.09   480.00     71.34%
  349114 requests in 1.00m, 62.93MB read
  Socket errors: connect 0, read 193, write 1, timeout 0
Requests/sec:   5808.59
Transfer/sec:      1.05MB
```

*`dart:io`*:
```
Running 1m test @ http://localhost:3000
  25 threads and 200 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    38.27ms   80.62ms   1.73s    92.19%
    Req/Sec   469.27    339.75    12.45k    82.26%
  691289 requests in 1.00m, 114.71MB read
  Socket errors: connect 0, read 95, write 0, timeout 0
Requests/sec:  11501.56
Transfer/sec:      1.91MB
```

*ExpressJS*:
```
Running 1m test @ http://localhost:3000
  25 threads and 200 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency   157.17ms  218.66ms   1.51s    81.59%
    Req/Sec   511.46    559.69     6.81k    88.08%
  676474 requests in 1.00m, 250.31MB read
  Socket errors: connect 0, read 2, write 1, timeout 0
  Non-2xx or 3xx responses: 676474
Requests/sec:  11257.02
Transfer/sec:      4.17MB
```

500 connections:
```bash
wrk -c 500 -t 25 -d 60 http://localhost:3000
```

*Angel*:
```
Running 1m test @ http://localhost:3000
  25 threads and 500 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    33.15ms   30.35ms   1.27s    99.64%
    Req/Sec   417.67    256.10     1.11k    60.82%
  417792 requests in 1.00m, 75.30MB read
  Socket errors: connect 274, read 221, write 3, timeout 0
Requests/sec:   6951.12
Transfer/sec:      1.25MB
```

*`dart:io`*
```
Running 1m test @ http://localhost:3000
  25 threads and 500 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    29.05ms   74.15ms   1.74s    94.57%
    Req/Sec     0.90k   779.85    11.38k    85.71%
  734960 requests in 1.00m, 121.96MB read
  Socket errors: connect 274, read 44, write 10, timeout 0
Requests/sec:  12228.17
Transfer/sec:      2.03MB
```

*ExpressJS*:
```
Running 1m test @ http://localhost:3000
  25 threads and 500 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    95.84ms  183.75ms   1.53s    84.68%
    Req/Sec     0.90k     0.89k    6.69k    86.56%
  652997 requests in 1.00m, 241.63MB read
  Socket errors: connect 274, read 52, write 0, timeout 0
  Non-2xx or 3xx responses: 652997
Requests/sec:  10865.03
Transfer/sec:      4.02MB
```

1000 connections:

*Angel*:
```
Running 1m test @ http://localhost:3000
  25 threads and 1000 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    32.94ms   26.96ms   1.17s    99.48%
    Req/Sec   647.43    504.47     1.61k    40.79%
  418926 requests in 1.00m, 75.51MB read
  Socket errors: connect 774, read 191, write 3, timeout 0
Requests/sec:   6972.22
Transfer/sec:      1.26MB
```

*`dart:io`*:
```
Running 1m test @ http://localhost:3000
  25 threads and 1000 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    22.25ms   57.86ms   1.61s    94.88%
    Req/Sec     1.15k     1.22k   15.68k    85.20%
  727176 requests in 1.00m, 120.67MB read
  Socket errors: connect 774, read 39, write 1, timeout 0
Requests/sec:  12100.28
Transfer/sec:      2.01MB
```

*ExpressJS*:
```
Running 1m test @ http://localhost:3000
  25 threads and 1000 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    61.48ms  159.59ms   1.81s    88.68%
    Req/Sec   706.93    783.29     6.20k    86.46%
  633907 requests in 1.00m, 234.56MB read
  Socket errors: connect 774, read 23, write 0, timeout 1
  Non-2xx or 3xx responses: 633907
Requests/sec:  10547.60
Transfer/sec:      3.90MB
```

2500 connections:
```bash
wrk -c 2500 -t 25 -d 60 http://localhost:3000
```

*Angel*:
```
Running 1m test @ http://localhost:3000
  25 threads and 2500 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    31.92ms   16.10ms   1.21s    99.66%
    Req/Sec     1.20k     1.10k    3.85k    78.98%
  425830 requests in 1.00m, 76.75MB read
  Socket errors: connect 2274, read 24, write 0, timeout 0
Requests/sec:   7085.14
Transfer/sec:      1.28MB
```

*`dart:io`*:
```
Running 1m test @ http://localhost:3000
  25 threads and 2500 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    18.30ms   32.23ms 887.77ms   95.06%
    Req/Sec   512.17    553.94     6.97k    89.32%
  748616 requests in 1.00m, 124.22MB read
  Socket errors: connect 2274, read 41, write 0, timeout 0
Requests/sec:  12458.17
Transfer/sec:      2.07MB
```

*ExpressJS*:
```
Running 1m test @ http://localhost:3000
  25 threads and 2500 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    23.78ms   79.26ms   1.66s    93.62%
    Req/Sec     1.91k     1.52k    9.45k    71.51%
  541119 requests in 1.00m, 200.23MB read
  Socket errors: connect 2274, read 0, write 0, timeout 0
  Non-2xx or 3xx responses: 541119
Requests/sec:   9004.47
Transfer/sec:      3.33MB
```

5000 connections:
```bash
wrk -c 5000 -t 25 -d 60 http://localhost:3000
```

*Angel*:
```
Running 1m test @ http://localhost:3000
  25 threads and 5000 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    33.60ms   11.72ms 796.02ms   97.38%
    Req/Sec   285.15    493.29     3.22k    88.17%
  403509 requests in 1.00m, 72.73MB read
  Socket errors: connect 4774, read 27, write 0, timeout 0
Requests/sec:   6714.35
Transfer/sec:      1.21MB
```

*`dart:io`*:
```
Running 1m test @ http://localhost:3000
  25 threads and 5000 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    18.53ms   33.84ms 776.03ms   95.17%
    Req/Sec   497.85    780.56     8.79k    93.76%
  725709 requests in 1.00m, 120.42MB read
  Socket errors: connect 4774, read 42, write 1, timeout 0
Requests/sec:  12073.98
Transfer/sec:      2.00MB
```

*ExpressJS*:
```
Running 1m test @ http://localhost:3000
  25 threads and 5000 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    20.21ms  100.34ms   1.57s    96.66%
    Req/Sec   812.07      0.89k    9.44k    86.22%
  654186 requests in 1.00m, 242.07MB read
  Socket errors: connect 4774, read 0, write 0, timeout 0
  Non-2xx or 3xx responses: 654186
Requests/sec:  10882.82
Transfer/sec:      4.03MB
```

10000 connections:
```bash
wrk -c 10000 -t 25 -d 60 http://localhost:3000
```

*dart:io*:
```
Running 1m test @ http://localhost:3000
  25 threads and 10000 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    11.35ms   16.72ms 254.17ms   92.83%
    Req/Sec   797.17      1.25k   13.48k    87.25%
  1153670 requests in 1.00m, 191.44MB read
  Socket errors: connect 9774, read 0, write 0, timeout 0
Requests/sec:  19196.21
Transfer/sec:      3.19MB
```