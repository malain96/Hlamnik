import 'package:floor/floor.dart';
import 'package:flutter/widgets.dart';
import 'package:hlamnik/database/entities/brand.dart';
import 'package:hlamnik/database/entities/category.dart';
import 'package:hlamnik/database/entities/color.dart';
import 'package:hlamnik/database/entities/season.dart';
import 'package:json_annotation/json_annotation.dart';

part 'item.g.dart';

/// Defines the [Item] table
@Entity(
  foreignKeys: [
    ForeignKey(
      childColumns: ['brand_id'],
      parentColumns: ['id'],
      entity: Brand,
    ),
    ForeignKey(
      childColumns: ['category_id'],
      parentColumns: ['id'],
      entity: Category,
    ),
  ],
)
@JsonSerializable(nullable: false)
class Item {
  @primaryKey
  int id;
  String title;
  double quality;
  double rating;
  String picture;
  String comment;
  String purchaseYear;
  bool isBroken;
  final String createdAt;
  @ColumnInfo(name: 'category_id')
  int categoryId;
  @ColumnInfo(name: 'brand_id')
  int brandId;
  @ignore
  Category category;
  @ignore
  Brand brand;
  @ignore
  List<Season> seasons;
  @ignore
  List<Color> colors;

  Item({
    @required this.id,
    @required this.title,
    @required this.quality,
    @required this.rating,
    @required this.picture,
    @required this.comment,
    @required this.isBroken,
    @required this.purchaseYear,
    this.brandId,
    this.categoryId,
    this.category,
    this.brand,
    this.seasons,
    this.colors,
  }) : createdAt = DateTime.now().toIso8601String();

  ///Converts JSON to Item
  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
  ///Converts Item to JSON
  Map<String, dynamic> toJson() => _$ItemToJson(this);
}
