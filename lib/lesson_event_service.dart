import 'dart:async';

/// Подія зміни розкладу.
class LessonEvent {
  final String action;
  final String subject;

  const LessonEvent(this.action, this.subject);

  @override
  String toString() => '$action: $subject';
}

/// Джерело подій, пов'язаних із розкладом.
class LessonEventService {
  final StreamController<LessonEvent> _controller =
      StreamController<LessonEvent>();

  Stream<LessonEvent> get events => _controller.stream;

  void addEvent(String action, String subject) {
    _controller.add(LessonEvent(action, subject));
  }

  Future<void> close() => _controller.close();
}
