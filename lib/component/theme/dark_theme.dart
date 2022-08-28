import 'package:flutter/material.dart';

import 'common.dart';

ThemeData darkTheme() {
  MaterialColor primaryColor = Colors.blue;
  Color backgroundColor = Colors.grey.shade900;
  Color accentColor = Colors.blue.shade200;

  var themeData = ThemeData.dark();

  themeData = themeData.copyWith(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSwatch(
      brightness: Brightness.dark,
      primarySwatch: primaryColor,
      accentColor: accentColor,
      backgroundColor: backgroundColor,
    ),
    primaryColor: primaryColor.shade500,
    scaffoldBackgroundColor: backgroundColor,
    cardTheme: appCardTheme.copyWith(surfaceTintColor: backgroundColor),
    appBarTheme: appAppBarTheme.copyWith(shadowColor: Colors.black),
    drawerTheme: appDrawerThemeData,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.grey.shade900,
    ),
    pageTransitionsTheme: appPageTransitionsTheme,
    scrollbarTheme: appScrollBarThemeData,
    textButtonTheme: appTextButtonThemeData,
    toggleableActiveColor: primaryColor,
    checkboxTheme: appCheckboxThemeData.copyWith(
      fillColor: MaterialStateProperty.all(primaryColor),
    ),
    switchTheme: appSwitchThemeData.copyWith(
      thumbColor: MaterialStateProperty.all(accentColor),
    ),
  );

  return themeData;
}
