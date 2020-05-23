import 'dart:async';
import 'package:floor/floor.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:hlamnik/database/dao/category_dao.dart';
import 'package:hlamnik/database/dao/color_dao.dart';
import 'package:hlamnik/database/dao/item_dao.dart';
import 'package:hlamnik/database/dao/season_dao.dart';
import 'package:hlamnik/database/entities/category.dart';
import 'package:hlamnik/database/entities/color.dart';
import 'package:hlamnik/database/entities/item.dart';
import 'package:hlamnik/database/entities/item_season.dart';
import 'package:hlamnik/database/entities/season.dart';

part 'database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [
  Category,
  Color,
  Item,
  ItemSeason,
  Season,
])
abstract class AppDatabase extends FloorDatabase {
  CategoryDao get categoryDao;

  ColorDao get colorDao;

  ItemDao get itemDao;

  SeasonDao get seasonDao;
}
