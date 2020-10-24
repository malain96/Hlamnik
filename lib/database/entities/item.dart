import 'package:floor/floor.dart';
import 'package:flutter/widgets.dart';
import 'package:hlamnik/database/entities/brand.dart';
import 'package:hlamnik/database/entities/category.dart';
import 'package:hlamnik/database/entities/color.dart';
import 'package:hlamnik/database/entities/season.dart';

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
class Item {
  @primaryKey
  int id;
  String title;
  double quality;
  double rating;
  String picture;
  String comment;
  String purchaseYear;
  final String createdAt;
  @ignore
  Color color;
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
    @required this.purchaseYear,
    this.brandId,
    this.categoryId,
    this.color,
    this.category,
    this.brand,
    this.seasons,
    this.colors,
  }) : createdAt = DateTime.now().toIso8601String();

  ///Clones an existing [Item]
  Item.clone(Item item)
      : this(
          id: item.id,
          title: item.title,
          quality: item.quality,
          rating: item.rating,
          picture: item.picture,
          comment: item.comment,
          purchaseYear: item.purchaseYear,
          categoryId: item.categoryId,
          brandId: item.brandId,
          brand: item.brand,
          color: item.color,
          category: item.category,
          seasons: item.seasons,
          colors: item.colors,
        );
}
