import 'package:floor/floor.dart';

@entity
class Season {
  @primaryKey
  final int id;
  String name;

  Season({
    this.id,
    this.name,
  });
}