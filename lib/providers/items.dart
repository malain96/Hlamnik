import 'package:flutter/material.dart';
import 'package:hlamnik/database/entities/item.dart';
import 'package:hlamnik/database/entities/item_season.dart';
import 'package:hlamnik/models/filter.dart';
import 'package:hlamnik/services/db_service.dart';

class Items with ChangeNotifier {
  List<Item> _items = [];

  List<Item> get items {
    return _items;
  }

  Future addItem(Item item) async {
    final db = await DBService.getDatabase;
    final addedItemId = await db.itemDao.insertItem(item);
    await Future.forEach(
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

  Future loadItems() async {
    final db = await DBService.getDatabase;
    _items = await db.itemDao.listAll();
    notifyListeners();
  }

  Future filterItems(Filter filter) async {
    final db = await DBService.getDatabase;
    var filteredItems = await db.itemDao.listAllWithSeasons();
    // Remove all items which have a quality lower than the filter
    if (filter.quality != null) {
      filteredItems.removeWhere((item) => item.quality < filter.quality);
    }
    // Remove all items which have a rating lower than the filter
    if (filter.rating != null) {
      filteredItems.removeWhere((item) => item.rating < filter.rating);
    }
    // Remove all items which are not part of the selected category
    if (filter.categoryId != null) {
      filteredItems.removeWhere((item) => item.categoryId != filter.categoryId);
    }
    // Remove all items which are not part of the selected season
    if (filter.seasonId != null) {
      filteredItems.removeWhere(
        (item) => item.seasons != null
            ? item.seasons
                .where((season) => season.id == filter.seasonId)
                .isEmpty
            : false,
      );
    }
    // Remove all items which are not part of the selected color
    if (filter.colorId != null) {
      filteredItems.removeWhere((item) => item.colorId != filter.colorId);
    }

    _items = filteredItems;
    notifyListeners();
  }
}
