import 'package:floor/floor.dart';
import 'package:hlamnik/database/dao/abstract_dao.dart';
import 'package:hlamnik/database/entities/brand.dart';

/// Dao to perform CRUD operations in the [Brand] table
@dao
abstract class BrandDao extends AbstractDao<Brand> {
  ///Query the database and returns all [Brand]
  @Query('SELECT * FROM Brand ORDER BY name ASC')
  Future<List<Brand>> listAll();

  ///Query the database and returns the [Brand] with the given [id]
  @Query('SELECT * FROM Brand WHERE id = :id')
  Future<Brand> findById(int id);
}
