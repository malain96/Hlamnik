import 'package:floor/floor.dart';
import 'package:flutter/painting.dart' as flutter;
import 'package:supercharged/supercharged.dart';

/// Defines the [Color] table
@entity
class Color {
  @primaryKey
  final int id;
  String code;

  Color({
    this.id,
    this.code,
  });

  flutter.Color get getColor {
    return code.toColor();
  }
}
