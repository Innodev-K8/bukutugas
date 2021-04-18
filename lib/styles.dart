import 'package:flutter/material.dart';

class AppTheme {
  static final orange = Color(0xFFF8A488);
  static final darkBlue = Color(0xFF45526C);
  static final accentDarkBlue = Color(0xFF8996AE);
  static final sheetBg = Color(0xFFF8F5F1);
  static final accentSheetBg = Color(0xFFE8E3DD);
  static final green = Color(0xFF5AA897);

  static final rounded = BorderRadius.circular(6);
  static final roundedLg = BorderRadius.circular(12);

  static final TextStyle errorTextStyle = TextStyle();

  static final lightTheme = ThemeData(
    fontFamily: 'Montserrat',
    backgroundColor: darkBlue,
    primaryColor: orange,
    accentColor: green,
    primaryColorLight: Colors.white,
    shadowColor: accentDarkBlue.withOpacity(0.1),
    dialogBackgroundColor: sheetBg,
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: accentSheetBg,
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.white,
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      contentPadding: const EdgeInsets.all(10),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: AppTheme.rounded,
      ),
      labelStyle: TextStyle(
        color: darkBlue.withOpacity(0.4),
      ),
    ),
    textTheme: TextTheme(
      // icon
      bodyText1: TextStyle(
        fontFamily: 'Noto',
        fontSize: 28.0,
      ),
      bodyText2: TextStyle(color: darkBlue),

      headline1: TextStyle(
        color: Colors.white,
        fontSize: 24.0,
        fontWeight: FontWeight.w600,
      ),
      headline2: TextStyle(
        color: darkBlue,
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
      ),
      headline3: TextStyle(
        color: Colors.white,
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
      ),
      headline4: TextStyle(
        color: darkBlue,
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
      ),
      headline5: TextStyle(
        color: Colors.white,
        fontSize: 10.0,
        fontWeight: FontWeight.normal,
      ),
      headline6: TextStyle(
        color: accentDarkBlue,
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
