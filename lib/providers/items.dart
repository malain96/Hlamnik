import 'package:flutter/material.dart';
import 'package:hlamnik/database/entities/item.dart';
import 'package:hlamnik/database/entities/item_color.dart';
import 'package:hlamnik/database/entities/item_season.dart';
import 'package:hlamnik/models/filter.dart';
import 'package:hlamnik/services/db_service.dart';

///[Provider] used to manage a list of [Item] across all screens
class Items with ChangeNotifier {
  List<Item> _items = [];

  List<Item> get items {
    return _items;
  }

  ///Retrieve a list of all [Item] from the database sorted by rating
  Future<List<Item>> get _getItems async {
    final db = await DBService.getDatabase;
    final items = await db.itemDao.listAllWithJoins();
    //Sort by rating
    items.sort((a, b) => b.rating.compareTo(a.rating));
    return items;
  }

  ///Add a new [Item] to the database
  Future<void> addItem(Item item) async {
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
    await Future.forEach(
      item.colors,
      (color) async => await db.itemColorDao.insertValue(
        ItemColor(
          itemId: addedItemId,
          colorId: color.id,
        ),
      ),
    );
    item.id = addedItemId;
    _items.add(item);
    notifyListeners();
  }

  ///Update an existing [Item] in the database
  Future<void> updateItem(Item item) async {
    final itemIndex = _items.indexWhere((i) => i.id == item.id);
    final oldItem = _items[itemIndex];
    final db = await DBService.getDatabase;
    await db.itemDao.updateValue(item);
    // Retrieve a list of seasons to delete and to add
    final seasonsToDelete = oldItem.seasons.where((oldSeason) =>
        !item.seasons.map((season) => season.name).contains(oldSeason.name));
    final seasonsToAdd = item.seasons.where((season) => !oldItem.seasons
        .map((oldSeason) => oldSeason.name)
        .contains(season.name));
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
    // Retrieve a list of colors to delete and to add
    final colorsToDelete = oldItem.colors.where((oldColor) =>
        !item.colors.map((color) => color.code).contains(oldColor.code));
    final colorsToAdd = item.colors.where((color) =>
        !oldItem.colors.map((oldColor) => oldColor.code).contains(color.code));
    // Delete and add the itemColors after mapping the color to an itemColor
    await db.itemColorDao.deleteValues(
      colorsToDelete
          .map(
            (color) => ItemColor(itemId: item.id, colorId: color.id),
          )
          .toList(),
    );
    await db.itemColorDao.insertValues(
      colorsToAdd
          .map(
            (color) => ItemColor(itemId: item.id, colorId: color.id),
          )
          .toList(),
    );

    _items[itemIndex] = item;
    notifyListeners();
  }

  ///Load all [Item] from the database
  Future<void> loadItems() async {
    _items = await _getItems;
    notifyListeners();
  }

  ///Filter the list of [Item]
  Future<void> filterItems(Filter filter) async {
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
    // Remove all items which don't have all the selected colors
    if (filter.colorIdList != null) {
      filteredItems.removeWhere(
        (item) => item.colors != null
            ? item.colors
                    .where((color) => filter.colorIdList.contains(color.id))
                    .length !=
                filter.colorIdList.length
            : false,
      );
    }
    // Remove all items which are not broken
    if (filter.showOnlyIsBroken) {
      filteredItems.removeWhere((item) => !item.isBroken);
    }

    _items = filteredItems;
    notifyListeners();
  }

  ///Returns the [Item] with the given [id]
  Item getItem(int id) {
    return items.firstWhere((item) => item.id == id);
  }

  ///Deletes an existing [Item] from the database
  Future<void> deleteItem(Item item) async {
    final db = await DBService.getDatabase;
    final itemSeasonList = await db.itemSeasonDao.findSeasonIdsByItem(item.id);
    final itemColorList = await db.itemColorDao.findColorIdsByItem(item.id);
    //Delete the linked seasons and colors
    await db.itemSeasonDao.deleteValues(itemSeasonList);
    await db.itemColorDao.deleteValues(itemColorList);
    await db.itemDao.deleteValue(item);
    _items.removeWhere((i) => i.id == item.id);
    notifyListeners();
  }
}
