import 'package:floor/floor.dart';

@entity
class Category {
  @primaryKey
  final int id;
  String name;

  Category({
    this.id,
    this.name,
  });
}