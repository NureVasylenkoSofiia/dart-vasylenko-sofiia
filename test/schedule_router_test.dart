import 'dart:convert';
import 'dart:io';

import 'package:group_schedule/group_schedule.dart';
import 'package:group_schedule/src/server/schedule_router.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  late Directory tempDirectory;
  late JsonScheduleStorage storage;
  late Handler handler;
  late Lesson originalLesson;

  setUp(() async {
    tempDirectory = await Directory.systemTemp.createTemp(
      'schedule_server_test_',
    );

    storage = JsonScheduleStorage(tempDirectory.path);

    originalLesson = Lesson.fromCsv(
      'Математика;Іваненко І.І.;Практика;'
      'Понеділок;09:30;А-101;2026-11-02',
    );

    await storage.save([originalLesson]);

    handler = buildScheduleRouter(storage).call;
  });

  tearDown(() async {
    await tempDirectory.delete(recursive: true);
  });

  group('Schedule HTTP API', () {
    test('GET /items повертає список занять', () async {
      final request = Request('GET', Uri.parse('http://localhost/items'));

      final response = await handler(request);
      final data = jsonDecode(await response.readAsString()) as List;

      expect(response.statusCode, 200);
      expect(data, hasLength(1));
      expect(data.first['subject'], 'Математика');
      expect(response.headers['content-type'], contains('application/json'));
    });

    test('GET /items підтримує фільтрацію', () async {
      final request = Request(
        'GET',
        Uri.parse('http://localhost/items?subject=Dart'),
      );

      final response = await handler(request);
      final data = jsonDecode(await response.readAsString()) as List;

      expect(response.statusCode, 200);
      expect(data, isEmpty);
    });

    test('GET /items/id повертає заняття', () async {
      final encodedId = base64Url
          .encode(utf8.encode(originalLesson.id))
          .replaceAll('=', '');

      final request = Request(
        'GET',
        Uri.parse('http://localhost/items/$encodedId'),
      );

      final response = await handler(request);
      final data =
          jsonDecode(await response.readAsString()) as Map<String, dynamic>;

      expect(response.statusCode, 200);
      expect(data['subject'], 'Математика');
    });

    test('GET /items/id повертає 404', () async {
      final request = Request(
        'GET',
        Uri.parse('http://localhost/items/missing-id'),
      );

      final response = await handler(request);

      expect(response.statusCode, 404);
    });

    test('POST /items створює заняття', () async {
      final newLesson = Lesson.fromCsv(
        'Історія України;Коваленко К.К.;Лекція;'
        'Четвер;11:00;А-210;2026-11-05',
      );

      final request = Request(
        'POST',
        Uri.parse('http://localhost/items'),
        headers: {'content-type': 'application/json; charset=utf-8'},
        body: utf8.encode(jsonEncode(newLesson.toJson())),
      );

      final response = await handler(request);
      final lessons = await storage.load();

      expect(response.statusCode, 201);
      expect(lessons, hasLength(2));
      expect(lessons.last.subject, 'Історія України');
    });

    test('POST /items повертає 400 для поганого JSON', () async {
      final request = Request(
        'POST',
        Uri.parse('http://localhost/items'),
        headers: {'content-type': 'application/json'},
        body: '{invalid json}',
      );

      final response = await handler(request);

      expect(response.statusCode, 400);
    });

    test('POST /items повертає 409 для дубліката', () async {
      final request = Request(
        'POST',
        Uri.parse('http://localhost/items'),
        headers: {'content-type': 'application/json; charset=utf-8'},
        body: utf8.encode(jsonEncode(originalLesson.toJson())),
      );

      final response = await handler(request);
      final lessons = await storage.load();

      expect(response.statusCode, 409);
      expect(lessons, hasLength(1));
    });
  });
}
