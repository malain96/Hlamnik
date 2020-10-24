import 'dart:async';
import 'package:floor/floor.dart';
import 'package:hlamnik/database/dao/brand_dao.dart';
import 'package:hlamnik/database/dao/item_color_dao.dart';
import 'package:hlamnik/database/dao/item_season_dao.dart';
import 'package:hlamnik/database/entities/brand.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:hlamnik/database/dao/category_dao.dart';
import 'package:hlamnik/database/dao/color_dao.dart';
import 'package:hlamnik/database/dao/item_dao.dart';
import 'package:hlamnik/database/dao/season_dao.dart';
import 'package:hlamnik/database/entities/category.dart';
import 'package:hlamnik/database/entities/color.dart';
import 'package:hlamnik/database/entities/item.dart';
import 'package:hlamnik/database/entities/item_season.dart';
import 'package:hlamnik/database/entities/item_color.dart';
import 'package:hlamnik/database/entities/season.dart';

//Run 'flutter packages pub run build_runner build' to generate
part 'database.g.dart'; // the generated code will be there

///Class used to generate the database and the daos' queries
@Database(version: 1, entities: [
  Category,
  Color,
  Item,
  ItemSeason,
  ItemColor,
  Season,
  Brand,
])
abstract class AppDatabase extends FloorDatabase {
  CategoryDao get categoryDao;

  ColorDao get colorDao;

  ItemDao get itemDao;

  SeasonDao get seasonDao;

  ItemSeasonDao get itemSeasonDao;

  ItemColorDao get itemColorDao;

  BrandDao get brandDao;
}
