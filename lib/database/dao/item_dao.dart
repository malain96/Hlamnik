import 'package:floor/floor.dart';
import 'package:hlamnik/database/dao/abstract_dao.dart';
import 'package:hlamnik/database/entities/item.dart';
import 'package:hlamnik/services/db_service.dart';

/// Dao to perform CRUD operations in the [Item] table
@dao
abstract class ItemDao extends AbstractDao<Item> {
  ///Query the database and returns all [Item]
  @Query('SELECT * FROM Item')
  Future<List<Item>> listAll();

  ///Query the database and returns all [Item] with their children
  Future<List<Item>> listAllWithJoins() async {
    final db = await DBService.getDatabase;
    final items = await listAll();
    await Future.forEach(items, (Item item) async {
      final itemSeasonList =
          await db.itemSeasonDao.findSeasonIdsByItem(item.id);
      item.seasons = await db.seasonDao.findByIds(
        itemSeasonList.map((itemSeason) => itemSeason.seasonId).toList(),
      );
      item.category = await db.categoryDao.findById(item.categoryId);
      item.color = await db.colorDao.findById(item.colorId);
    });
    return items;
  }
}
