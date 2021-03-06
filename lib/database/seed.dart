import 'package:easy_localization/easy_localization.dart';
import 'package:hlamnik/generated/locale_keys.g.dart';
import 'package:hlamnik/database/entities/color.dart';
import 'package:hlamnik/database/entities/season.dart';
import 'package:hlamnik/services/db_service.dart';

class Seed {
  /// Seeds the database with default values on the first run of the app
  static Future<void> initDB() async {
    final database = await DBService.getDatabase;
    final colorDao = database.colorDao;
    final seasonDao = database.seasonDao;

    final colors = await colorDao.listAll();
    final seasons = await seasonDao.listAll();

    if (colors.isEmpty) {
      await colorDao.insertValue(
        Color(
          id: 1,
          code: 'FFFFFF',
        ),
      );
      await colorDao.insertValue(
        Color(
          id: 2,
          code: '000000',
        ),
      );
      await colorDao.insertValue(
        Color(
          id: 3,
          code: 'FF0000',
        ),
      );
      await colorDao.insertValue(
        Color(
          id: 4,
          code: 'FFFF00',
        ),
      );
      await colorDao.insertValue(
        Color(
          id: 5,
          code: '0000FF',
        ),
      );
      await colorDao.insertValue(
        Color(
          id: 6,
          code: '008000',
        ),
      );
      await colorDao.insertValue(
        Color(
          id: 7,
          code: '800080',
        ),
      );
      await colorDao.insertValue(
        Color(
          id: 8,
          code: 'C0C0C0',
        ),
      );
      await colorDao.insertValue(
        Color(
          id: 9,
          code: '000080',
        ),
      );
      await colorDao.insertValue(
        Color(
          id: 10,
          code: '800000',
        ),
      );
    }

    if (seasons.isEmpty) {
      await seasonDao.insertValue(
        Season(
          id: 1,
          name: LocaleKeys.winter.tr(),
        ),
      );await seasonDao.insertValue(
        Season(
          id: 2,
          name: LocaleKeys.fall.tr(),
        ),
      );await seasonDao.insertValue(
        Season(
          id: 3,
          name: LocaleKeys.summer.tr(),
        ),
      );await seasonDao.insertValue(
        Season(
          id: 4,
          name: LocaleKeys.autumn.tr(),
        ),
      );
    }
  }
}
