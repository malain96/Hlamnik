import 'package:easy_localization/easy_localization.dart';
import 'package:hlamnik/database/entities/category.dart';
import 'package:hlamnik/database/entities/color.dart';
import 'package:hlamnik/database/entities/season.dart';
import 'package:hlamnik/services/db_service.dart';

class Seed {
  static Future<void> initDB() async {
    final database = await DBService.getDatabase;
    final categoryDao = database.categoryDao;
    final colorDao = database.colorDao;
    final seasonDao = database.seasonDao;

    final categories = await categoryDao.listAll();
    final colors = await colorDao.listAll();
    final seasons = await seasonDao.listAll();

    if (categories.length == 0) {
      categoryDao.insertItem(
        Category(
          id: 1,
          name: 'pants'.tr(),
        ),
      );
      categoryDao.insertItem(
        Category(
          id: 2,
          name: 'tshirt'.tr(),
        ),
      );
      categoryDao.insertItem(
        Category(
          id: 3,
          name: 'sweater'.tr(),
        ),
      );
    }

    if (colors.length == 0) {
      colorDao.insertItem(
        Color(
          id: 1,
          code: 'FFFFFF',
        ),
      );
      colorDao.insertItem(
        Color(
          id: 2,
          code: '000000',
        ),
      );
      colorDao.insertItem(
        Color(
          id: 3,
          code: 'FF0000',
        ),
      );
      colorDao.insertItem(
        Color(
          id: 4,
          code: 'FFFF00',
        ),
      );
      colorDao.insertItem(
        Color(
          id: 5,
          code: '0000FF',
        ),
      );
      colorDao.insertItem(
        Color(
          id: 6,
          code: '008000',
        ),
      );
      colorDao.insertItem(
        Color(
          id: 7,
          code: '800080',
        ),
      );
      colorDao.insertItem(
        Color(
          id: 8,
          code: 'C0C0C0',
        ),
      );
      colorDao.insertItem(
        Color(
          id: 9,
          code: '000080',
        ),
      );
      colorDao.insertItem(
        Color(
          id: 10,
          code: '800000',
        ),
      );
    }

    if (seasons.length == 0) {
      seasonDao.insertItem(
        Season(
          id: 1,
          name: 'winter'.tr(),
        ),
      );seasonDao.insertItem(
        Season(
          id: 2,
          name: 'fall'.tr(),
        ),
      );seasonDao.insertItem(
        Season(
          id: 3,
          name: 'summer'.tr(),
        ),
      );seasonDao.insertItem(
        Season(
          id: 4,
          name: 'autumn'.tr(),
        ),
      );
    }
  }
}
