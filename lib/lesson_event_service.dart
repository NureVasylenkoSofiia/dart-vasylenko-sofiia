import 'dart:async';

/// Подія зміни розкладу.
class LessonEvent {
  /// Тип дії над заняттям.
  final String action;

  /// Назва дисципліни, якої стосується подія.
  final String subject;

  /// Створює подію зміни розкладу.
  const LessonEvent(this.action, this.subject);

  @override
  String toString() => '$action: $subject';
}

/// Джерело подій, пов'язаних із розкладом.
class LessonEventService {
  final StreamController<LessonEvent> _controller =
      StreamController<LessonEvent>();

  /// Потік подій зміни розкладу.
  Stream<LessonEvent> get events => _controller.stream;

  /// Додає нову подію до потоку.
  void addEvent(String action, String subject) {
    _controller.add(LessonEvent(action, subject));
  }

  /// Передає повідомлення про помилку до потоку.
  void addError(Object error) {
    _controller.addError(error);
  }

  /// Закриває потік подій та звільняє ресурси.
  Future<void> close() => _controller.close();
}
