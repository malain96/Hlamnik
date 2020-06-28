import 'package:floor/floor.dart';
import 'package:hlamnik/database/dao/abstract_dao.dart';
import 'package:hlamnik/database/entities/category.dart';

@dao
abstract class CategoryDao extends AbstractDao<Category> {
  @Query('SELECT * FROM Category')
  Future<List<Category>> listAll();

  @Query('SELECT * FROM Category WHERE id = :id')
  Future<Category> findById(int id);
}
