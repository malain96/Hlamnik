import 'package:floor/floor.dart';

/// Abstract class use to extend all daos and perform basic insert/delete/update actions
abstract class AbstractDao<T> {
  ///Inserts the given [value] in the database and returns the generated id
  @insert
  Future<int> insertValue(T value);

  ///Inserts the given [values] in the database and returns a list of generated id
  @insert
  Future<List<int>> insertValues(List<T> values);

  ///Updates the given [value] in the database and returns the number of affected rows
  @update
  Future<int> updateValue(T value);

  ///Updates the given [values] in the database and returns the number of affected rows
  @update
  Future<int> updateValues(List<T> values);

  ///Deletes the given [value] in the database and returns the number of affected rows
  @delete
  Future<int> deleteValue(T value);

  ///Updates the given [values] in the database and returns the number of affected rows
  @delete
  Future<int> deleteValues(List<T> values);
}
