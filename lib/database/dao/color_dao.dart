import 'package:floor/floor.dart';
import 'package:hlamnik/database/dao/abstract_dao.dart';
import 'package:hlamnik/database/entities/color.dart';

@dao
abstract class ColorDao extends AbstractDao<Color> {
  @Query('SELECT * FROM Color')
  Future<List<Color>> listAll();

  @Query('SELECT * FROM Color WHERE code = :code')
  Future<Color> findByCode(String code);
}
