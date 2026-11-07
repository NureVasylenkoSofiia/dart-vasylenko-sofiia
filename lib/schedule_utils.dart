/// Створює незалежний лічильник оброблених записів.
///
/// Повернена функція збільшує лічильник на один
/// і повертає його поточне значення.
int Function() createRecordCounter() {
  var count = 0;

  return () {
    count++;
    return count;
  };
}

/// Регулярний вираз для перевірки номера аудиторії.
final RegExp roomPattern = RegExp(
  r'^(?<building>[А-ЯІЇЄҐA-Z])-(?<number>\d{3})$',
);

/// Перевіряє правильність формату аудиторії [room].
bool isValidRoom(String room) {
  return roomPattern.hasMatch(room);
}

/// Маскує перші дві цифри номера аудиторії [room].
///
/// Наприклад, «А-101» перетворюється на «А-**1».
String maskRoom(String room) {
  return room.replaceAllMapped(roomPattern, (match) {
    final regexMatch = match as RegExpMatch;

    final building = regexMatch.namedGroup('building') ?? '';
    final number = regexMatch.namedGroup('number') ?? '';

    return '$building-**${number.substring(2)}';
  });
}

/// Обчислює кількість календарних днів між [lessonDate] і [currentDate].
///
/// Додатне значення означає, що заняття вже відбулося.
/// Від'ємне — що дата заняття ще попереду.
int daysSinceLesson(DateTime lessonDate, {DateTime? currentDate}) {
  final now = currentDate ?? DateTime.now();

  final lessonDay = DateTime.utc(
    lessonDate.year,
    lessonDate.month,
    lessonDate.day,
  );

  final today = DateTime.utc(now.year, now.month, now.day);

  final Duration difference = today.difference(lessonDay);

  return difference.inDays;
}
