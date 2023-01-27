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
      backgroundColor: Colors.grey.shade600,
    ),
    pageTransitionsTheme: appPageTransitionsTheme,
    scrollbarTheme: appScrollBarThemeData,
    textButtonTheme: appTextButtonThemeData,
    sliderTheme: appSliderThemeData,
    chipTheme: appChipThemeData.copyWith(selectedColor: primaryColor),
    checkboxTheme: appCheckboxThemeData.copyWith(
      fillColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return primaryColor;
        }
        return null;
      }),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return backgroundColor;
        }
        return null;
      }),
    ),
    switchTheme: appSwitchThemeData.copyWith(
      thumbColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return primaryColor;
        }
        return null;
      }),
      trackColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return accentColor;
        }
        return null;
      }),
    ),
  );

  return themeData;
}
