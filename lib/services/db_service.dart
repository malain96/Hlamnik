import 'dart:convert';
import 'dart:io';

import 'package:ext_storage/ext_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hlamnik/database/database.dart';
import 'package:hlamnik/database/entities/brand.dart';
import 'package:hlamnik/database/entities/category.dart';
import 'package:hlamnik/database/entities/color.dart';
import 'package:hlamnik/database/entities/item.dart';
import 'package:hlamnik/database/entities/item_color.dart';
import 'package:hlamnik/database/entities/item_season.dart';
import 'package:hlamnik/database/entities/season.dart';
import 'package:permission_handler/permission_handler.dart';

class DBService {
  ///Retrieves an instance of the database so we can query it
  static Future<AppDatabase> get getDatabase async {
    // Create or connect to the database
    return await $FloorAppDatabase.databaseBuilder('hlamnik.db').build();
  }

  ///Exports the db to a json file
  static void exportDb() async {
    final db = await DBService.getDatabase;
    final brands = await db.brandDao.listAll();
    final categories = await db.categoryDao.listAll();
    final colors = await db.colorDao.listAll();
    final seasons = await db.seasonDao.listAll();
    final items = await db.itemDao.listAllWithJoins();

    final json = {
      'brands': brands.map((brand) => brand.toJson()).toList(),
      'categories': categories.map((category) => category.toJson()).toList(),
      'colors': colors.map((color) => color.toJson()).toList(),
      'seasons': seasons.map((season) => season.toJson()).toList(),
      'items': items.map((item) => item.toJson()).toList(),
    };

    final status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    final path = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);
    final file = await File('$path/hlamnik.json');
    await file.writeAsString(jsonEncode(json));
  }

  ///Imports data to the database from a JSON File
  static void importDb() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null) {
      final file = File(result.files.single.path);
      final json = jsonDecode(await file.readAsString());
      final List<Brand> brands =
          json['brands'].map<Brand>((brand) => Brand.fromJson(brand)).toList();
      final List<Category> categories = json['categories']
          .map<Category>((category) => Category.fromJson(category))
          .toList();
      final List<Color> colors =
          json['colors'].map<Color>((color) => Color.fromJson(color)).toList();
      final List<Season> seasons = json['seasons']
          .map<Season>((season) => Season.fromJson(season))
          .toList();
      final List<Item> items =
          json['items'].map<Item>((item) => Item.fromJson(item)).toList();
      var itemColorList = <ItemColor>[];
      var itemSeasonList = <ItemSeason>[];
      items.forEach((item) {
        item.colors.forEach(
          (color) =>
              itemColorList.add(ItemColor(colorId: color.id, itemId: item.id)),
        );
        item.seasons.forEach(
          (season) => itemSeasonList
              .add(ItemSeason(seasonId: season.id, itemId: item.id)),
        );
      });

      final db = await DBService.getDatabase;
      await db.brandDao.insertValues(brands);
      await db.categoryDao.insertValues(categories);
      await db.colorDao.insertValues(colors);
      await db.seasonDao.insertValues(seasons);
      await db.itemDao.insertValues(items);
      await db.itemColorDao.insertValues(itemColorList);
      await db.itemSeasonDao.insertValues(itemSeasonList);
    }
  }
}
