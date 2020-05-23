import 'package:floor/floor.dart';
import 'package:hlamnik/database/dao/abstract_dao.dart';
import 'package:hlamnik/database/entities/item.dart';


@dao
abstract class ItemDao extends AbstractDao<Item> {
  @Query('SELECT * FROM Item')
  Future<List<Item>> listAll();

  @Query('SELECT * FROM Item WHERE id = :id')
  Future<Item> findItemById(int id);
}
