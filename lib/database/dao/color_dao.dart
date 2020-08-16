import 'package:floor/floor.dart';
import 'package:hlamnik/database/dao/abstract_dao.dart';
import 'package:hlamnik/database/entities/color.dart';

/// Dao to perform CRUD operations in the [Color] table
@dao
abstract class ColorDao extends AbstractDao<Color> {
  ///Query the database and returns all [Color]
  @Query('SELECT * FROM Color')
  Future<List<Color>> listAll();

  ///Query the database and returns the [Color] with the given [code]
  @Query('SELECT * FROM Color WHERE code = :code')
  Future<Color> findByCode(String code);

  ///Query the database and returns the [Color] with the given [id]
  @Query('SELECT * FROM Color WHERE id = :id')
  Future<Color> findById(int id);

  ///Query the database and returns the [Color] with the given [id]
  @Query('SELECT * FROM Color WHERE id IN (:ids)')
  Future<List<Color>> findByIds(List<int> ids);
}
