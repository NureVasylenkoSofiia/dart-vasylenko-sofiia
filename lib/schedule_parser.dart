/// Один запис розкладу занять.
typedef ScheduleEntry = ({
  String subject,
  String teacher,
  String lessonType,
  String weekday,
  int startMinutes,
  String room,
  DateTime date,
});

/// Розбирає рядок [line] у запис розкладу.
///
/// Повертає `null`, якщо формат рядка некоректний.
ScheduleEntry? parseScheduleLine(String line) {
  final fields = line.split(';');

  if (fields.length != 7) {
    return null;
  }

  final subject = fields[0].trim();
  final teacher = fields[1].trim();
  final lessonType = fields[2].trim();
  final weekday = fields[3].trim();
  final timeText = fields[4].trim();
  final room = fields[5].trim();
  final dateText = fields[6].trim();

  if (subject.isEmpty ||
      teacher.isEmpty ||
      lessonType.isEmpty ||
      weekday.isEmpty ||
      room.isEmpty) {
    return null;
  }

  final timeParts = timeText.split(':');

  if (timeParts.length != 2) {
    return null;
  }

  final hours = int.tryParse(timeParts[0]);
  final minutes = int.tryParse(timeParts[1]);
  final date = DateTime.tryParse(dateText);

  if (hours == null || minutes == null || date == null) {
    return null;
  }

  final normalizedDate =
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  if (dateText != normalizedDate) {
    return null;
  }

  if (hours < 0 || hours > 23 || minutes < 0 || minutes > 59) {
    return null;
  }

  return (
    subject: subject,
    teacher: teacher,
    lessonType: lessonType,
    weekday: weekday,
    startMinutes: hours * 60 + minutes,
    room: room,
    date: date,
  );
}
