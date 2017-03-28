import 'dart:io';
import 'dart:isolate';
import 'package:angel_perf/angel_perf.dart';

main(List<String> args, [SendPort sendPort]) async {
  bool allowCrash = args.contains('allow-crash');

  var app = await createServer(!allowCrash);

  if (allowCrash) {
    // Usually, Angel proactively catches runtime errors
    // to prevent crashes, but within our child servers,
    // we will deliberately rethrow errors.
    app.fatalErrorStream.listen((e) {
      print('Crash: ${e.error}');
      print(e.stack);
      throw e.error;
    });
  }

  var server = await app.startServer(
      InternetAddress.LOOPBACK_IP_V4, allowCrash ? 0 : 3000);
  sendPort?.send([server.address.address, server.port]);
}
