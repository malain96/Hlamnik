import 'package:floor/floor.dart';
import 'package:hlamnik/database/dao/abstract_dao.dart';
import 'package:hlamnik/database/entities/season.dart';

/// Dao to perform CRUD operations in the [Season] table
@dao
abstract class SeasonDao extends AbstractDao<Season> {
  ///Query the database and returns all [Season]
  @Query('SELECT * FROM Season')
  Future<List<Season>> listAll();

  ///Query the database and returns the [Season] with the given [id]
  @Query('SELECT * FROM Season WHERE id IN (:ids)')
  Future<List<Season>> findByIds(List<int> ids);
}
