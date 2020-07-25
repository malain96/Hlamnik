import 'package:flutter/material.dart';

///Defines the main theme of the app
final ThemeData mainTheme = _buildMainTheme();

//const kPrimaryColor = Color(0xFFD48166);
//const kSecondaryColor = Color(0xFF373A36);
//const kTertiaryColor = Color(0xFFE6E2DD);

///Defines the main colors of the app
class AppColors {
  static const primaryColor = Color(0xFFC6AD8F);
  static const secondaryColor = Color(0xFF425664);
  static const tertiaryColor = Color(0xFFF6F4F2);
  static const errorColor = Color(0xFFFA8072);
}

///Builds the main theme
ThemeData _buildMainTheme() {
  final base = ThemeData.light();

  return ThemeData(
    primaryColor: AppColors.primaryColor,
    accentColor: AppColors.secondaryColor,
    textTheme: _buildMainTextTheme(base.textTheme),
    appBarTheme: _buildMainAppBarTheme(
      base.appBarTheme,
      base.textTheme,
      base.iconTheme,
    ),
    floatingActionButtonTheme:
        _buildMainFloatingActionButtonTheme(base.floatingActionButtonTheme),
    iconTheme: _buildMainIconTheme(base.iconTheme),
    canvasColor: AppColors.tertiaryColor,
    cursorColor: AppColors.primaryColor,
    textSelectionColor: AppColors.primaryColor,
    errorColor: AppColors.errorColor,
    inputDecorationTheme:
        _buildMainInputDecorationTheme(base.inputDecorationTheme),
  );
}

///Builds the main text theme
TextTheme _buildMainTextTheme(TextTheme base) {
  return base
      .copyWith(
        headline1: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      )
      .apply(
        bodyColor: AppColors.secondaryColor,
        displayColor: AppColors.secondaryColor,
      );
}

///Builds the main appBar theme
AppBarTheme _buildMainAppBarTheme(
    AppBarTheme base, TextTheme textBase, IconThemeData iconBase) {
  return base.copyWith(
    actionsIconTheme: iconBase.copyWith(color: AppColors.tertiaryColor),
    iconTheme: iconBase.copyWith(color: AppColors.tertiaryColor),
    textTheme: textBase.copyWith(
      headline6: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.tertiaryColor,
      ),
    ),
  );
}

///Builds the main icon theme
IconThemeData _buildMainIconTheme(IconThemeData base) {
  return base.copyWith(color: AppColors.primaryColor);
}

///Builds the main floating action button theme
FloatingActionButtonThemeData _buildMainFloatingActionButtonTheme(
    FloatingActionButtonThemeData base) {
  return base.copyWith(
    focusColor: AppColors.tertiaryColor,
    backgroundColor: AppColors.primaryColor,
  );
}

///Builds the main input decoration theme
InputDecorationTheme _buildMainInputDecorationTheme(InputDecorationTheme base) {
  return base.copyWith(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(
        color: AppColors.secondaryColor,
      ),
    ),
    labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
  );
}
