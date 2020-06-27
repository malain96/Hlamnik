import 'package:floor/floor.dart';
import 'package:hlamnik/database/dao/abstract_dao.dart';
import 'package:hlamnik/database/entities/item.dart';
import 'package:hlamnik/services/db_service.dart';

@dao
abstract class ItemDao extends AbstractDao<Item> {
  @Query('SELECT * FROM Item')
  Future<List<Item>> listAll();

  @Query('SELECT * FROM Item WHERE id = :id')
  Future<Item> findItemById(int id);

  Future<List<Item>> listAllWithSeasons() async {
    final db = await DBService.getDatabase;
    final items = await listAll();
    await Future.forEach(items, (Item item) async {
      final itemSeasonList =
          await db.itemSeasonDao.findSeasonIdsByItem(item.id);
      item.seasons = await db.seasonDao.getByIds(
        itemSeasonList.map((itemSeason) => itemSeason.seasonId).toList(),
      );
    });
    return items;
  }
}
