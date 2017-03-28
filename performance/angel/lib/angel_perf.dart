import 'dart:async';
import 'dart:io';
import 'package:angel_framework/angel_framework.dart';
import 'src/tests/json.dart';

Future<Angel> createServer([bool shared]) async {
  var app = shared ? new Angel() : new Angel.custom(startShared);

  app.get('/json', jsonTest);

  return app;
}

Future<HttpServer> startShared(InternetAddress address, int port) {
  print('wtf');
  var host = address ?? InternetAddress.LOOPBACK_IP_V4;
  var p = port ?? 0;
  return HttpServer.bind(host, p, shared: true);
}
