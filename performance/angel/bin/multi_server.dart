import 'dart:io';
import 'package:angel_multiserver/angel_multiserver.dart';

final Uri CLUSTER = Uri.parse('cluster.dart');

main() async {
  int i = 0;
  var app = new LoadBalancer(maxConcurrentConnections: 25)
    ..onBoot.listen((_) {
      print('Spawned isolate #${++i}...');
    });

  await app.spawnIsolates(CLUSTER, count: 25, args: ['allow-crash']);
  app.onCrash.listen((_) => app.spawnIsolates(CLUSTER, args: ['allow-crash']));
  await app.startServer(InternetAddress.LOOPBACK_IP_V4, 3000);
  print('Angel multiserver listening at http://localhost:3000');
}
