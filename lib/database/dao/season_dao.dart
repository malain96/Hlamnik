import 'package:floor/floor.dart';
import 'package:hlamnik/database/dao/abstract_dao.dart';
import 'package:hlamnik/database/entities/season.dart';

@dao
abstract class SeasonDao extends AbstractDao<Season> {
  @Query('SELECT * FROM Season')
  Future<List<Season>> listAll();
}
