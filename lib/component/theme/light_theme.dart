import 'package:flutter/material.dart';

import 'common.dart';

ThemeData lightTheme() {
  MaterialColor primaryColor = Colors.blue;
  Color backgroundColor = Colors.grey.shade200;
  Color accentColor = Colors.lightBlue.shade100;

  var themeData = ThemeData.light();

  themeData = themeData.copyWith(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: primaryColor,
      backgroundColor: backgroundColor,
      accentColor: accentColor,
    ),
    primaryColor: Colors.blue.shade500,
    scaffoldBackgroundColor: backgroundColor,
    cardTheme: appCardTheme.copyWith(surfaceTintColor: accentColor),
    appBarTheme: appAppBarTheme.copyWith(
      shadowColor: Colors.black87,
      backgroundColor: backgroundColor,
      titleTextStyle: appAppBarTheme.titleTextStyle?.copyWith(
        color: Colors.black87,
      ),
    ),
    drawerTheme: appDrawerThemeData,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.grey.shade200,
      elevation: 5,
      foregroundColor: Colors.black87,
    ),
    pageTransitionsTheme: appPageTransitionsTheme,
    textButtonTheme: appTextButtonThemeData,
    checkboxTheme: appCheckboxThemeData.copyWith(
      fillColor: MaterialStateProperty.all(primaryColor),
    ),
    switchTheme: appSwitchThemeData.copyWith(
      thumbColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        return primaryColor;
      }),
      trackColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        return accentColor;
      }),
    ),
    sliderTheme: appSliderThemeData,
    chipTheme: appChipThemeData.copyWith(selectedColor: primaryColor),
  );

  return themeData;
}
