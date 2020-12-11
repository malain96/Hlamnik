import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

/// Defines the [Category] table
@entity
@JsonSerializable(nullable: false)
class Category {
  @primaryKey
  int id;
  String name;

  Category({
    this.id,
    this.name,
  });

  @override
  String toString() => name;

  ///Converts JSON to Category
  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
  ///Converts Category to JSON
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}