import 'package:flutter/material.dart';

import 'common.dart';

ThemeData lightTheme() {
  var themeData = ThemeData.light();

  themeData = themeData.copyWith(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSwatch(
      accentColor: Colors.blue.shade500,
      backgroundColor: Colors.grey.shade300,
    ),
    scaffoldBackgroundColor: Colors.grey.shade300,
    cardTheme: buildCardTheme(),
    appBarTheme: buildAppBarTheme().copyWith(
      shadowColor: Colors.black87,
      backgroundColor: themeData.scaffoldBackgroundColor,
      titleTextStyle: buildAppBarTheme().titleTextStyle?.copyWith(
            color: Colors.black87,
          ),
    ),
    drawerTheme: buildDrawerThemeData(),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.grey.shade200,
      elevation: 5,
      foregroundColor: themeData.colorScheme.primary.withOpacity(.5),
    ),
    pageTransitionsTheme: buildPageTransitionsTheme(),
    textButtonTheme: buildTextButtonThemeData(),
  );

  return themeData;
}
