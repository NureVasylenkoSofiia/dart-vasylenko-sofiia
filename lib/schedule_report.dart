import 'schedule_parser.dart';
import 'schedule_statistics.dart';

/// Формує текстовий звіт за списком занять [entries].
///
/// [topCount] визначає максимальну кількість записів.
/// [ascending] задає напрям сортування за часом.
/// [separator] розділяє поля одного заняття.
String buildScheduleReport(
  List<ScheduleEntry> entries, {
  int topCount = 5,
  bool ascending = true,
  String separator = ' | ',
}) {
  final buffer = StringBuffer();
  final sorted = sortByStartTime(entries, ascending: ascending);
  final selected = sorted.take(topCount);

  buffer.writeln('=== ЗВІТ ПРО РОЗКЛАД ЗАНЯТЬ ===');
  buffer.writeln('Загальна кількість занять: ${entries.length}');
  buffer.writeln('Показано записів: ${selected.length}');
  buffer.writeln('');

  for (final entry in selected) {
    final hours = (entry.startMinutes ~/ 60).toString().padLeft(2, '0');
    final minutes = (entry.startMinutes % 60).toString().padLeft(2, '0');

    buffer.writeln(
      '${entry.subject}$separator'
      '${entry.teacher}$separator'
      '${entry.weekday}$separator'
      '$hours:$minutes$separator'
      '${entry.room}',
    );
  }

  return buffer.toString();
}
