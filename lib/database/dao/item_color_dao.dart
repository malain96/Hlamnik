import 'package:floor/floor.dart';
import 'package:hlamnik/database/entities/item_color.dart';

import 'abstract_dao.dart';

/// Dao to perform CRUD operations in the [ItemColor] table
@dao
abstract class ItemColorDao extends AbstractDao<ItemColor> {

  ///Query the database and returns all [ItemColor] of the given [itemId]
  @Query('SELECT * FROM ItemColor WHERE item_id=:itemId')
  Future<List<ItemColor>> findColorIdsByItem(int itemId);
}