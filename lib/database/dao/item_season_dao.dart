import 'package:floor/floor.dart';
import 'package:hlamnik/database/entities/item_season.dart';

import 'abstract_dao.dart';

/// Dao to perform CRUD operations in the [ItemSeason] table
@dao
abstract class ItemSeasonDao extends AbstractDao<ItemSeason> {

  ///Query the database and returns all [ItemSeason] of the given [itemId]
  @Query('SELECT * FROM ItemSeason WHERE item_id=:itemId')
  Future<List<ItemSeason>> findSeasonIdsByItem(int itemId);
}