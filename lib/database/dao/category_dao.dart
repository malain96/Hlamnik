import 'package:floor/floor.dart';
import 'package:hlamnik/database/dao/abstract_dao.dart';
import 'package:hlamnik/database/entities/category.dart';

/// Dao to perform CRUD operations in the [Category] table
@dao
abstract class CategoryDao extends AbstractDao<Category> {
  ///Query the database and returns all [Category]
  @Query('SELECT * FROM Category')
  Future<List<Category>> listAll();

  ///Query the database and returns the [Category] with the given [id]
  @Query('SELECT * FROM Category WHERE id = :id')
  Future<Category> findById(int id);
}
