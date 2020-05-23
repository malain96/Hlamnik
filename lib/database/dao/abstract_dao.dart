import 'package:floor/floor.dart';

abstract class AbstractDao<T> {
  @insert
  Future<void> insertItem(T item);
}