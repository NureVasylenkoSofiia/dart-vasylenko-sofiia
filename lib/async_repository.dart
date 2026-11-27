import 'dart:async';

import 'package:group_schedule/repository.dart';

/// Асинхронне сховище об'єктів із властивістю id.
class AsyncRepository<T extends Identifiable> {
  final Map<String, T> _items = {};

  /// Затримка, яка імітує асинхронну операцію зі сховищем.
  final Duration delay;

  /// Повертає кількість збережених об'єктів.
  AsyncRepository({this.delay = const Duration(milliseconds: 300)});

  /// Зберігає об'єкт за його ідентифікатором.
  Future<void> save(T item) async {
    await Future<void>.delayed(delay);
    _items[item.id] = item;
  }

  /// Завантажує об'єкт або повертає null, якщо його немає.
  Future<T?> load(String id) async {
    await Future<void>.delayed(delay);
    return _items[id];
  }

  /// Видаляє об'єкт за ідентифікатором.
  Future<bool> delete(String id) async {
    await Future<void>.delayed(delay);
    return _items.remove(id) != null;
  }

  /// Поступово видає всі збережені об'єкти.
  Stream<T> watchAll() async* {
    print('Генератор watchAll() почав виконуватися');

    for (final item in _items.values.toList()) {
      await Future<void>.delayed(delay);
      yield item;
    }

    print('Генератор watchAll() завершився');
  }
}
