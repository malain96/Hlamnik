import 'package:floor/floor.dart';
import 'package:flutter/painting.dart' as flutter;
import 'package:supercharged/supercharged.dart';
import 'package:json_annotation/json_annotation.dart';

part 'color.g.dart';

/// Defines the [Color] table
@entity
@JsonSerializable(nullable: false)
class Color {
  @primaryKey
  int id;
  String code;

  Color({
    this.id,
    this.code,
  });

  flutter.Color get getColor {
    return code.toColor();
  }

  ///Converts JSON to Color
  factory Color.fromJson(Map<String, dynamic> json) => _$ColorFromJson(json);
  ///Converts Color to JSON
  Map<String, dynamic> toJson() => _$ColorToJson(this);
}
