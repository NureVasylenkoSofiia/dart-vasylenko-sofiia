import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../storage/json_schedule_storage.dart';
import '../models/lesson.dart';
import '../../lesson_validator.dart';

/// Створює маршрути HTTP-сервісу розкладу.
Router buildScheduleRouter(JsonScheduleStorage storage) {
  final router = Router();

  const jsonHeaders = {'content-type': 'application/json; charset=utf-8'};

  // Отримання всіх занять із можливістю фільтрації.
  router.get('/items', (Request request) async {
    final lessons = await storage.load();

    final subject = request.url.queryParameters['subject'];

    final filtered = subject == null
        ? lessons
        : lessons
              .where(
                (lesson) => lesson.subject.toLowerCase().contains(
                  subject.toLowerCase(),
                ),
              )
              .toList();

    final body = jsonEncode(filtered.map((lesson) => lesson.toJson()).toList());

    return Response.ok(utf8.encode(body), headers: jsonHeaders);
  });

  // Отримання заняття за ідентифікатором.
  router.get('/items/<id>', (Request request, String id) async {
    String lessonId;

    try {
      lessonId = utf8.decode(base64Url.decode(base64Url.normalize(id)));
    } on FormatException {
      return Response.notFound(
        utf8.encode(jsonEncode({'error': 'Некоректний ID'})),
        headers: jsonHeaders,
      );
    }

    final lessons = await storage.load();

    for (final lesson in lessons) {
      if (lesson.id == lessonId) {
        return Response.ok(
          utf8.encode(jsonEncode(lesson.toJson())),
          headers: jsonHeaders,
        );
      }
    }

    return Response.notFound(
      utf8.encode(jsonEncode({'error': 'Заняття не знайдено'})),
      headers: jsonHeaders,
    );
  });

  // Створення нового заняття через HTTP POST.
  router.post('/items', (Request request) async {
    try {
      final body = await request.readAsString();
      final decoded = jsonDecode(body);

      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Тіло запиту повинно містити JSON-об’єкт');
      }

      final lesson = Lesson.fromJson(decoded);

      final errors = validateLesson(lesson);

      if (errors.isNotEmpty) {
        return Response(
          400,
          body: utf8.encode(jsonEncode({'error': errors.join('; ')})),
          headers: jsonHeaders,
        );
      }

      final lessons = await storage.load();

      if (lessons.any((item) => item.id == lesson.id)) {
        return Response(
          409,
          body: utf8.encode(jsonEncode({'error': 'Таке заняття вже існує'})),
          headers: jsonHeaders,
        );
      }

      lessons.add(lesson);
      await storage.save(lessons);

      return Response(
        201,
        body: utf8.encode(jsonEncode(lesson.toJson())),
        headers: jsonHeaders,
      );
    } on FormatException catch (error) {
      return Response(
        400,
        body: utf8.encode(jsonEncode({'error': error.message})),
        headers: jsonHeaders,
      );
    } on TypeError {
      return Response(
        400,
        body: utf8.encode(jsonEncode({'error': 'Некоректні типи полів JSON'})),
        headers: jsonHeaders,
      );
    }
  });
  return router;
}
