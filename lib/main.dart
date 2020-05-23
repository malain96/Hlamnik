import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hlamnik/database/entities/category.dart';
import 'package:hlamnik/screens/item_list_screen.dart';
import 'package:hlamnik/services/db_service.dart';
import 'package:hlamnik/themes/main_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = await DBService.getDatabase;
  database.categoryDao.insertItem(Category(name: 'Test'));
  //@TODO Create a seeder to create default seasons, categories and colors

  runApp(
    EasyLocalization(
        supportedLocales: [Locale('en'), Locale('fr'), Locale('ru')],
        path: 'assets/translations',
        fallbackLocale: Locale('en'),
        child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Hlamnik',
      theme: mainTheme,
      home: ItemListScreen(),
    );
  }
}
