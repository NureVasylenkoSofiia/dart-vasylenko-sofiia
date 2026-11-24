import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

import 'package:group_schedule/group_schedule.dart';
import 'package:group_schedule/src/server/schedule_router.dart';

Future<void> main() async {
  final storage = JsonScheduleStorage(Directory.current.path);

  final router = buildScheduleRouter(storage);

  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addHandler(router.call);

  final server = await shelf_io.serve(
    handler,
    InternetAddress.loopbackIPv4,
    8080,
  );

  print('HTTP-сервер запущено');
  print('Адреса: http://${server.address.host}:${server.port}');
}
