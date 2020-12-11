import 'package:floor/floor.dart';
import 'package:hlamnik/database/entities/item.dart';
import 'package:hlamnik/database/entities/color.dart';

/// Defines the [ItemColor] table
@Entity(
  primaryKeys: ['item_id', 'color_id'],
  foreignKeys: [
    ForeignKey(
      childColumns: ['item_id'],
      parentColumns: ['id'],
      entity: Item,
    ),
    ForeignKey(
      childColumns: ['color_id'],
      parentColumns: ['id'],
      entity: Color,
    ),
  ],
)
class ItemColor {
  @ColumnInfo(name: 'item_id')
  final int itemId;
  @ColumnInfo(name: 'color_id')
  final int colorId;

  ItemColor({this.itemId, this.colorId});
}
