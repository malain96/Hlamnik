import 'package:floor/floor.dart';

/// Defines the [Category] table
@entity
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
}