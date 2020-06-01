import 'package:flutter/material.dart';
import 'package:hlamnik/database/entities/item.dart';
import 'package:hlamnik/database/entities/item_season.dart';
import 'package:hlamnik/services/db_service.dart';

class Items with ChangeNotifier {
  List<Item> _items = [];

  List<Item> get items {
    return _items;
  }

  Future addItem(Item item) async {
    final db = await DBService.getDatabase;
    final addedItemId = await db.itemDao.insertItem(item);
    Future.forEach(
      item.seasons,
      (season) async => await db.itemSeasonDao.insertItem(
        ItemSeason(
          itemId: addedItemId,
          seasonId: season.id,
        ),
      ),
    );
    item.id = addedItemId;
    _items.add(item);
    notifyListeners();
  }
}
