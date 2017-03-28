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
| Angel               | 5808.59          | 6972.22          | 6450.4775
| Angel (multiserver) | 0                | 0                | 0
| Aqueduct            | 0                | 0                | 0

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

*Angel Multiserver*:
```
```

*Aqueduct*:

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

2500 connections:
```bash
wrk -c 2500 -t 25 -d 60 http://localhost:3000
```

*All*:

```
unable to create thread 6: Too many open files
```

5000 connections:
```bash
wrk -c 5000 -t 25 -d 60 http://localhost:3000
```

*All*:

```
unable to create thread 6: Too many open files
```

10000 connections:
```bash
wrk -c 10000 -t 25 -d 60 http://localhost:3000
```

*All*:

```
unable to create thread 6: Too many open files
```