import 'package:flutter/material.dart';

// Define the main theme of the app
final ThemeData mainTheme = _buildMainTheme();

//const kPrimaryColor = Color(0xFFD48166);
//const kSecondaryColor = Color(0xFF373A36);
//const kTertiaryColor = Color(0xFFE6E2DD);

const kPrimaryColor = Color(0xFFC6AD8F);
const kSecondaryColor = Color(0xFF425664);
const kTertiaryColor = Color(0xFFF6F4F2);

// Build the theme
ThemeData _buildMainTheme() {
  final ThemeData base = ThemeData.light();

  return ThemeData(
    primaryColor: kPrimaryColor,
    accentColor: kSecondaryColor,
    textTheme: _buildMainTextTheme(base.textTheme),
    appBarTheme: _buildMainAppBarTheme(
      base.appBarTheme,
      base.textTheme,
      base.iconTheme,
    ),
    floatingActionButtonTheme:
        _buildMainFloatingActionButtonTheme(base.floatingActionButtonTheme),
    iconTheme: _buildMainIconTheme(base.iconTheme),
    canvasColor: kTertiaryColor,
    cursorColor: kPrimaryColor,
    textSelectionColor: kPrimaryColor,
    inputDecorationTheme:
        _buildMainInputDecorationTheme(base.inputDecorationTheme),
  );
}

// Build the main text theme
TextTheme _buildMainTextTheme(TextTheme base) {
  return base
      .copyWith(
        subtitle1: TextStyle(
          color: kSecondaryColor,
        ),
      )
      .apply(
        bodyColor: kSecondaryColor,
        displayColor: kSecondaryColor,
      );
}

// Build the main appBar theme
AppBarTheme _buildMainAppBarTheme(
    AppBarTheme base, TextTheme textBase, IconThemeData iconBase) {
  return base.copyWith(
    actionsIconTheme: iconBase.copyWith(color: kTertiaryColor),
    iconTheme: iconBase.copyWith(color: kTertiaryColor),
    textTheme: textBase.copyWith(
      headline6: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: kTertiaryColor,
      ),
    ),
  );
}

// Build the main icon theme
IconThemeData _buildMainIconTheme(IconThemeData base) {
  return base.copyWith(color: kPrimaryColor);
}

// Build the main floating action button theme
FloatingActionButtonThemeData _buildMainFloatingActionButtonTheme(
    FloatingActionButtonThemeData base) {
  return base.copyWith(
    focusColor: kTertiaryColor,
    backgroundColor: kPrimaryColor,
  );
}

InputDecorationTheme _buildMainInputDecorationTheme(InputDecorationTheme base) {
  return base.copyWith(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(
        color: kSecondaryColor,
      ),
    ),
    labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
  );
}
