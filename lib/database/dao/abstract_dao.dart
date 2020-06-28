import 'package:floor/floor.dart';

abstract class AbstractDao<T> {
  @insert
  Future<int> insertValue(T value);

  @insert
  Future<List<int>> insertValues(List<T> values);

  @update
  Future<int> updateValue(T value);

  @update
  Future<int> updateValues(List<T> values);

  @delete
  Future<int> deleteValue(T value);

  @delete
  Future<int> deleteValues(List<T> values);
}