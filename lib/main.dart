import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hlamnik/database/seed.dart';
import 'package:hlamnik/providers/items.dart';
import 'package:hlamnik/screens/edit_item_screen.dart';
import 'package:hlamnik/screens/items_overview_screen.dart';
import 'package:hlamnik/themes/main_theme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Seed.initDB();

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
    return ChangeNotifierProvider(
        create: (_) => Items(),
        child: MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          title: 'Hlamnik',
          theme: mainTheme,
          home: ItemsOverviewScreen(),
          routes: {
            EditItemScreen.routeName: (ctx) => EditItemScreen(),
          },
        ));
  }
}
