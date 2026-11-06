import 'package:group_schedule/schedule_data.dart';
import 'package:group_schedule/schedule_parser.dart';
import 'package:group_schedule/schedule_validator.dart';
import 'package:group_schedule/schedule_statistics.dart';
import 'package:group_schedule/schedule_report.dart';

void main() {
  final validEntries = <ScheduleEntry>[];
  var rejectedCount = 0;

  print('=== РОЗКЛАД ЗАНЯТЬ ГРУПИ ===');
  print('Усього вхідних записів: ${rawSchedule.length}');
  print('');

  for (final (index, line) in rawSchedule.indexed) {
    final entry = parseScheduleLine(line);

    if (entry == null) {
      rejectedCount++;
      print('Запис ${index + 1}: ПОМИЛКА ФОРМАТУ');
      continue;
    }

    final errors = validateScheduleEntry(entry);

    if (errors.isNotEmpty) {
      rejectedCount++;
      print('Запис ${index + 1}: ПОМИЛКА ВАЛІДАЦІЇ');
      for (final error in errors) {
        print('  - $error');
      }
      continue;
    }

    validEntries.add(entry);

    print(
      'Запис ${index + 1}: OK — '
      '${entry.subject}, ${entry.weekday}, ${entry.room}',
    );
  }

  print('');
  print('=== ПІДСУМКИ ===');
  print('Коректних записів: ${validEntries.length}');
  print('Відхилених записів: $rejectedCount');
  print('');
  print('=== СТАТИСТИКА РОЗКЛАДУ ===');

  final laboratoryLessons = filterLaboratoryLessons(validEntries);
  final subjects = getUniqueSubjects(validEntries);
  final totalLessons = countLessons(validEntries);

  print('Лабораторних занять: ${laboratoryLessons.length}');
  print('Унікальних дисциплін: ${subjects.length}');
  print('Загальна кількість занять: $totalLessons');
  print('Дисципліни: ${subjects.join(', ')}');
  print('');
  print('=== ЗАНЯТТЯ ЗА ДНЯМИ ТИЖНЯ ===');

  final grouped = groupByWeekday(validEntries);
  final lessonsPerDay = countLessonsByWeekday(grouped);

  lessonsPerDay.forEach((weekday, count) {
    print('$weekday: $count');
  });

  print('');
  print('=== СОРТУВАННЯ ЗА ЧАСОМ (ЗРОСТАННЯ) ===');

  final byTime = sortByStartTime(validEntries);

  for (final entry in byTime.take(5)) {
    final hours = (entry.startMinutes ~/ 60).toString().padLeft(2, '0');
    final minutes = (entry.startMinutes % 60).toString().padLeft(2, '0');

    print('$hours:$minutes — ${entry.subject}');
  }

  print('');
  print('=== СОРТУВАННЯ ЗА ДИСЦИПЛІНОЮ (СПАДАННЯ) ===');

  final bySubject = sortBySubject(validEntries, ascending: false);

  for (final entry in bySubject.take(5)) {
    print(entry.subject);
  }

  print('');
  print(
    buildScheduleReport(
      validEntries,
      topCount: 5,
      ascending: true,
      separator: ' | ',
    ),
  );
}
