import 'package:flutter/material.dart';

import 'common.dart';

ThemeData darkTheme() {
  var themeData = ThemeData.dark();

  themeData = themeData.copyWith(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSwatch(
      brightness: Brightness.dark,
      backgroundColor: Colors.grey.shade900,
      accentColor: Colors.blue.shade500,
    ),
    scaffoldBackgroundColor: Colors.grey.shade900,
    cardTheme: buildCardTheme(),
    appBarTheme: buildAppBarTheme().copyWith(shadowColor: Colors.black),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: themeData.colorScheme.background,
    ),
    pageTransitionsTheme: buildPageTransitionsTheme(),
    scrollbarTheme: buildScrollBarThemeData(),
    textButtonTheme: buildTextButtonThemeData(),
  );

  return themeData;
}
