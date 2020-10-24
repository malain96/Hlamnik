import 'package:floor/floor.dart';

/// Defines the [Brand] table
@entity
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
}