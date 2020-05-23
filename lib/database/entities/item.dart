import 'package:floor/floor.dart';
import 'package:flutter/widgets.dart';
import 'package:hlamnik/database/entities/category.dart';
import 'package:hlamnik/database/entities/color.dart';
import 'package:hlamnik/database/entities/season.dart';

@Entity(
  foreignKeys: [
    ForeignKey(
      childColumns: ['color_id'],
      parentColumns: ['id'],
      entity: Color,
    ),
    ForeignKey(
      childColumns: ['category_id'],
      parentColumns: ['id'],
      entity: Category,
    ),
  ],
)
class Item {
  @primaryKey
  final int id;
  String title;
  double quality;
  double rating;
  String picture;
  String comment;
  final String createdAt;
  @ColumnInfo(name: 'color_id')
  int colorId;
  @ignore
  Color color;
  @ColumnInfo(name: 'category_id')
  int categoryId;
  @ignore
  Category category;
  @ignore
  List<Season> seasons;

  Item({
    @required this.id,
    @required this.title,
    @required this.quality,
    @required this.rating,
    @required this.picture,
    @required this.comment,
    this.colorId,
    this.categoryId,
    this.color,
    this.category,
    this.seasons,
  }) : createdAt = DateTime.now().toIso8601String();
}
