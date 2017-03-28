import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

final Uri CLUSTER = Uri.parse('cluster.dart');

main() async {
  int x = 0;
  var c = new Completer();
  var exit = new ReceivePort();
  List<Isolate> isolates = [];

  exit.listen((_) {
    if (++x >= 50) {
      c.complete();
    }
  });

  for (int i = 0; i < 50; i++) {
    var isolate = await Isolate.spawn(serverMain, null);
    isolates.add(isolate);
    print('Spawned isolate #${i + 1}...');

    isolate.addOnExitListener(exit.sendPort);
  }

  print('Angel listening at http://localhost:3000');
  await c.future;
}

serverMain(args) {
  return HttpServer
      .bind(InternetAddress.LOOPBACK_IP_V4, 3000, shared: true)
      .then((server) async {
    await for (var request in server) {
      var r = request.response;

      switch (request.uri.path) {
        case '/json':
          r
            ..headers.contentType = ContentType.JSON
            ..write(JSON.encode({
              "foo": "bar",
              "one": [2, "three"],
              "bar": {"baz": "quux"}
            }));
          break;
      }

      await r.close();
    }
  });
}
