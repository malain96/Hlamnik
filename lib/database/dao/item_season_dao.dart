import 'package:floor/floor.dart';
import 'package:hlamnik/database/entities/item_season.dart';

import 'abstract_dao.dart';

@dao
abstract class ItemSeasonDao extends AbstractDao<ItemSeason> {
  @Query('SELECT * FROM ItemSeason WHERE item_id=:itemId')
  Future<List<ItemSeason>> findSeasonIdsByItem(int itemId);
}