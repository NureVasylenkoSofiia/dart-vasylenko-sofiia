/// Додаткові методи для відображення дат занять.
extension ScheduleDateExtension on DateTime {
  /// Повертає дату у форматі ДД.ММ.РРРР.
  String toScheduleFormat() {
    final day = this.day.toString().padLeft(2, '0');
    final month = this.month.toString().padLeft(2, '0');
    final year = this.year.toString();

    return '$day.$month.$year';
  }
}
