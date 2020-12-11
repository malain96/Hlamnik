import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';

part 'season.g.dart';

/// Defines the [Season] table
@entity
@JsonSerializable(nullable: false)
class Season {
  @primaryKey
  final int id;
  String name;

  Season({
    this.id,
    this.name,
  });

  @override
  String toString() => name;

  ///Converts JSON to Season
  factory Season.fromJson(Map<String, dynamic> json) => _$SeasonFromJson(json);
  ///Converts Season to JSON
  Map<String, dynamic> toJson() => _$SeasonToJson(this);
}