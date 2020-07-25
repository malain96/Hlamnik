import 'package:floor/floor.dart';
import 'package:hlamnik/database/entities/item.dart';
import 'package:hlamnik/database/entities/season.dart';

/// Defines the [ItemSeason] table
@Entity(
  primaryKeys: ['item_id', 'season_id'],
  foreignKeys: [
    ForeignKey(
      childColumns: ['item_id'],
      parentColumns: ['id'],
      entity: Item,
    ),
    ForeignKey(
      childColumns: ['season_id'],
      parentColumns: ['id'],
      entity: Season,
    ),
  ],
)
class ItemSeason {
  @ColumnInfo(name: 'item_id')
  final int itemId;
  @ColumnInfo(name: 'season_id')
  final int seasonId;

  ItemSeason({this.itemId, this.seasonId});
}
