/// Обчислює навчальне навантаження за днями тижня
/// на великому згенерованому наборі занять.
Map<String, int> calculateHeavyStatistics(int count) {
  const weekdays = ['Понеділок', 'Вівторок', 'Середа', 'Четвер', 'П’ятниця'];

  final statistics = <String, int>{for (final day in weekdays) day: 0};

  for (var i = 0; i < count; i++) {
    final weekday = weekdays[i % weekdays.length];

    final duration = i % 3 == 0 ? 120 : 90;

    statistics.update(weekday, (value) => value + duration);
  }

  return statistics;
}
