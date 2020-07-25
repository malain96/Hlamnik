import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hlamnik/database/seed.dart';
import 'package:hlamnik/providers/items.dart';
import 'package:hlamnik/screens/edit_item_screen.dart';
import 'package:hlamnik/screens/item_details_screen.dart';
import 'package:hlamnik/screens/items_overview_screen.dart';
import 'package:hlamnik/themes/main_theme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    // Init translations
    EasyLocalization(
        supportedLocales: [Locale('en'), Locale('fr'), Locale('ru')],
        path: 'assets/translations',
        fallbackLocale: Locale('en'),
        child: MyApp()),
  );
}

///Main widget
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Seed.initDB();

    return ChangeNotifierProvider( //Provider containing items
        create: (_) => Items(),
        child: MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          title: 'Hlamnik',
          theme: mainTheme,
          home: ItemsOverviewScreen(),
          routes: {
            EditItemScreen.routeName: (_) => EditItemScreen(),
            ItemDetailsScreen.routeName: (_) => ItemDetailsScreen(),
          },
        ));
  }
}
