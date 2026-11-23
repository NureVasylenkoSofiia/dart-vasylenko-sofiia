import 'dart:convert';

import 'package:group_schedule/group_schedule.dart';

void main() {
  final lesson = Lesson.fromCsv(
    'Математика;Іваненко І.І.;Практика;Понеділок;09:30;А-101;2026-11-02',
  );

  final jsonText = jsonEncode(lesson.toJson());

  print('Серіалізований JSON:');
  print(jsonText);

  final decoded = jsonDecode(jsonText) as Map<String, dynamic>;
  final restoredLesson = Lesson.fromJson(decoded);

  print('');
  print('Відновлене заняття:');
  print(restoredLesson);

  print('');
  print('Об’єкти однакові: ${lesson == restoredLesson}');
}
