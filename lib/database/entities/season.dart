import 'package:floor/floor.dart';

/// Defines the [Season] table
@entity
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
}