# Performance
All tests are performed with
[wrk](https://github.com/wg/wrk)
and run on a system with the following specs:
* macOS Sierra
* 1.4 GHz Intel Core i5 Processor
* 8GB 1600 MHz DDR3

# Results
Naturally, the servers eventually maxed out under pressure,
because this is a casual computer, not a production server.

Results may rise on a more powerful processor, but I expect that
the standard deviation will remain relatively unchanged.

| Server              | Min. Conns./sec. | Max. Conns./sec. | Average Conns./sec.
| ---                 | ---              | ---              | ---
| Angel               | 5808.59          | 7085.14          | 6600.23
| Angel (multiserver) | 0                | 0                | 0
| Aqueduct            | 0                | 0                | 0
| ExpressJS           | 9004.47          | 11257.02         | 10491.69

Compared to Node.js, the DartVM is definitely lacking as an HTTP server.
Where Dart does have the advantage is that it presents a lot less latency on responses.
For what it's worth, though, Angel put up a good fight.

I'll try to do some peeking into Node's `http` library, as well as Express itself,
so as to boost Angel's numbers up. The goal for now is at least 8000 connections
per second.

# Tests
All tests are run for 1 whole minute, across 25 threads.
Each server is run across 50 isolates, except for the multiserver,
which is one isolate. The multiserver runs 25 child servers, each one
in its own isolate.

The tests are also run on the load balancer from
[`package:angel_multiserver`](https://github.com/angel-dart/multiserver),
in addition to on a plain Angel instance.

## Simple JSON
Endpoint: `/json`
Location in Angel project: `lib/src/tests/json.dart`
Location in Aqueduct project: *TODO*

Each server should respond with JSON equivalent to the following:

```json
{
    "foo": "bar",
    "one": [
        2,
        "three"
    ],
    "bar": {
        "baz": "quux"
    }
}
``` 

It is expected that the server sends a `Content-Type: application/json` header as well.

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

*All*:
```
unable to create thread 6: Too many open files
```