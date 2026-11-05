import 'package:group_schedule/schedule_data.dart';
import 'package:group_schedule/schedule_parser.dart';
import 'package:group_schedule/schedule_validator.dart';

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
}
