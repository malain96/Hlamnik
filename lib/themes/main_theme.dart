import 'package:flutter/material.dart';

// Define the main theme of the app
final ThemeData mainTheme = _buildMainTheme();

const kPrimaryColor = Color(0xFFD48166);
const kAccentColor = Color(0xFF373A36);
const kSecondaryColor = Color(0xFFE6E2DD);

//const kPrimaryColor = Color(0xFFC6AD8F);
//const kAccentColor = Color(0xFF425664);
//const kSecondaryColor = Color(0xFFF6F4F2);


// Build the theme
ThemeData _buildMainTheme() {
  return ThemeData(
    primaryColor: kPrimaryColor,
    accentColor: kSecondaryColor,
  );
}
