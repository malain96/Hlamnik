import 'package:floor/floor.dart';

@entity
class Color {
  @primaryKey
  final int id;
  String code;

  Color({
    this.id,
    this.code,
  });
}