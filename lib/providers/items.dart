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

  Future<List<Item>> get _getItems async {
    final db = await DBService.getDatabase;
    final items = await db.itemDao.listAllWithJoins();
    //Sort by rating
    items.sort((a, b) => b.rating.compareTo(a.rating));
    return items;
  }

  Future addItem(Item item) async {
    final db = await DBService.getDatabase;
    final addedItemId = await db.itemDao.insertValue(item);
    await Future.forEach(
      item.seasons,
      (season) async => await db.itemSeasonDao.insertValue(
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

  Future updateItem(Item item) async {
    final itemIndex = _items.indexWhere((i) => i.id == item.id);
    final oldItem = _items[itemIndex];
    final db = await DBService.getDatabase;
    await db.itemDao.updateValue(item);
    // Retrieve a list of seasons to delete and to add
    final seasonsToDelete =
        oldItem.seasons.where((season) => item.seasons.contains(season));
    final seasonsToAdd =
        item.seasons.where((season) => oldItem.seasons.contains(season));
    // Delete and add the itemSeasons after mapping the season to an itemSeason
    await db.itemSeasonDao.deleteValues(
      seasonsToDelete
          .map(
            (season) => ItemSeason(itemId: item.id, seasonId: season.id),
          )
          .toList(),
    );
    await db.itemSeasonDao.insertValues(
      seasonsToAdd
          .map(
            (season) => ItemSeason(itemId: item.id, seasonId: season.id),
          )
          .toList(),
    );

    _items[itemIndex] = item;
    notifyListeners();
  }

  Future loadItems() async {
    _items = await _getItems;
    notifyListeners();
  }

  Future filterItems(Filter filter) async {
    var filteredItems = await _getItems;
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

  Item getItem(int id) {
    return items.firstWhere((item) => item.id == id);
  }

  Future deleteItem(Item item) async {
    final db = await DBService.getDatabase;
    final itemSeasonList = await db.itemSeasonDao.findSeasonIdsByItem(item.id);
    await db.itemSeasonDao.deleteValues(itemSeasonList);
    await db.itemDao.deleteValue(item);
    _items.removeWhere((i) => i.id == item.id);
    notifyListeners();
  }
}
