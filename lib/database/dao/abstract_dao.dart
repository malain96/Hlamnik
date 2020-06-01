import 'package:floor/floor.dart';

abstract class AbstractDao<T> {
  @insert
  Future<int> insertItem(T item);
}