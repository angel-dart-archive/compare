# Performance
All tests are performed with
[wrk](https://github.com/wg/wrk)
and run on a system with the following specs:
* macOS Sierra
* 1.4 GHz Intel Core i5 Processor
* 8GB 1600 MHz DDR3

# Tests
All tests are run for 1 whole minute, across 25 threads.
Each server is run across 50 isolates, except for the multiserver,
which is one isolate. The multiserver runs 25 child servers, each one
in its own isolate.

The tests are also run on the load balancer from
[`package:angel_multiserver`](https://github.com/angel-dart/multiserver),
in addition to on a plain Angel instance.

In general, it is rare to be able to free up enough threads (open files)
to run the 10k simulation. If it runs, it is factored in. Otherwise, it is not.
10k requests/sec. amounts to 36 million requests/hour, which most applications will never see.


# Results
Naturally, the servers eventually maxed out under pressure,
because this is a casual computer, not a production server.

Results may rise on a more powerful processor, but I expect that
the standard deviation will remain relatively unchanged.

Angel has proven itself to be capable of consistent performance, even
at high loads. Especially with its production-mode optimizations, Angel
can be relied on to power your applications at scale.

TODO: Averages

# Individual Tests
* [Blank response](blank.md)
* [JSON](test.md)
* [Database Fetch](database.md)