/// Інтерфейс для об'єктів, які мають ідентифікатор.
abstract interface class Identifiable {
  /// Унікальний ідентифікатор об'єкта.
  String get id;
}

/// Узагальнене сховище об'єктів з ідентифікаторами.
class Repository<T extends Identifiable> {
  final Map<String, T> _items = {};

  /// Додає об'єкт до сховища.
  void add(T item) {
    _items[item.id] = item;
  }

  /// Шукає об'єкт за ідентифікатором.
  T? findById(String id) {
    return _items[id];
  }

  /// Повертає об'єкти, які відповідають умові.
  Iterable<T> where(bool Function(T) test) {
    return _items.values.where(test);
  }

  /// Повертає всі об'єкти сховища.
  Iterable<T> get all => _items.values;

  /// Кількість об'єктів у сховищі.
  int get count => _items.length;
}
