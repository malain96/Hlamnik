import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';

part 'brand.g.dart';

/// Defines the [Brand] table
@entity
@JsonSerializable(nullable: false)
class Brand {
  @primaryKey
  int id;
  String name;

  Brand({
    this.id,
    this.name,
  });

  @override
  String toString() => name;

  ///Converts JSON to Brand
  factory Brand.fromJson(Map<String, dynamic> json) => _$BrandFromJson(json);
  ///Converts Brand to JSON
  Map<String, dynamic> toJson() => _$BrandToJson(this);
}