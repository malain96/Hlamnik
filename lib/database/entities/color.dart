import 'package:floor/floor.dart';
import 'package:flutter/painting.dart' as flutter;

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
    return flutter.Color(int.parse('0xff$code'));
  }
}
