import 'dart:async';
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
    var isolate = await Isolate.spawnUri(CLUSTER, [], null);
    isolates.add(isolate);
    print('Spawned isolate #${i + 1}...');

    isolate.addOnExitListener(exit.sendPort);
  }

  print('Angel listening at http://localhost:3000');
  await c.future;
}
