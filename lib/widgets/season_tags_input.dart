import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:hlamnik/database/entities/season.dart';
import 'package:hlamnik/services/db_service.dart';
import 'package:hlamnik/themes/main_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hlamnik/widgets/input_bordered.dart';

class SeasonTagsInput extends StatelessWidget {
  final OnPressedCallback onPress;
  final List<Season> activeSeasons;
  final String error;

  const SeasonTagsInput({
    @required this.onPress,
    @required this.activeSeasons,
    this.error,
  });

  Future<List<Season>> get _seasons async {
    final db = await DBService.getDatabase;
    return await db.seasonDao.listAll();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Season>>(
      future: _seasons,
      builder: (context, seasonsSnapshot) {
        return InputBordered(
          childLeftPadding: 13,
          childRightPadding: 13,
          childTopPadding: 27,
          label: 'seasons'.tr(),
          error: error,
          child: Tags(
            alignment: WrapAlignment.spaceEvenly,
            itemCount:
                seasonsSnapshot.hasData ? seasonsSnapshot.data.length : 0,
            itemBuilder: seasonsSnapshot.hasData
                ? (int index) {
                    final season = seasonsSnapshot.data[index];
                    return ItemTags(
                      key: Key(index.toString()),
                      index: season.id,
                      title: season.name,
                      customData: season,
                      active: activeSeasons
                          .where((s) => s.id == season.id)
                          .isNotEmpty,
                      color: AppColors.tertiaryColor,
                      activeColor: AppColors.primaryColor,
                      textColor: AppColors.secondaryColor,
                      textActiveColor: AppColors.secondaryColor,
                      onPressed: onPress,
                      combine: ItemTagsCombine.withTextBefore,
                      icon: ItemTagsIcon(
                        icon: Icons.add,
                      ),
                      textStyle: TextStyle(fontSize: 12),
                    );
                  }
                : null,
          ),
        );
      },
    );
  }
}
