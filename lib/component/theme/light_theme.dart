import 'package:flutter/material.dart';

import 'common.dart';

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF00658F),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFC7E7FF),
  onPrimaryContainer: Color(0xFF001E2E),
  secondary: Color(0xFF4F616E),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFD2E5F5),
  onSecondaryContainer: Color(0xFF0B1D29),
  tertiary: Color(0xFF006494),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFCAE6FF),
  onTertiaryContainer: Color(0xFF001E30),
  error: Color(0xFFBA1A1A),
  errorContainer: Color(0xFFFFDAD6),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFF410002),
  background: Color(0xFFF8FDFF),
  onBackground: Color(0xFF001F25),
  surface: Color(0xFFF8FDFF),
  onSurface: Color(0xFF001F25),
  surfaceVariant: Color(0xFFDDE3EA),
  onSurfaceVariant: Color(0xFF41484D),
  outline: Color(0xFF71787E),
  onInverseSurface: Color(0xFFD6F6FF),
  inverseSurface: Color(0xFF00363F),
  inversePrimary: Color(0xFF86CFFF),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFF00658F),
  outlineVariant: Color(0xFFC1C7CE),
  scrim: Color(0xFF000000),
);

ThemeData lightTheme() {
  var themeData = ThemeData.light();
  var bgColor = Colors.grey.shade200;

  themeData = themeData.copyWith(
    colorScheme: lightColorScheme,
    scaffoldBackgroundColor: bgColor,
    cardTheme: appCardTheme.copyWith(elevation: 0),
    appBarTheme: appAppBarTheme.copyWith(
      backgroundColor: bgColor,
      scrolledUnderElevation: 3,
      titleTextStyle: appAppBarTheme.titleTextStyle?.copyWith(
        color: Colors.black87,
      ),
    ),
    drawerTheme: appDrawerThemeData,
    pageTransitionsTheme: appPageTransitionsTheme,
    textButtonTheme: appTextButtonThemeData,
    checkboxTheme: appCheckboxThemeData,
    switchTheme: appSwitchThemeData,
    sliderTheme: appSliderThemeData,
    chipTheme: appChipThemeData,
    dialogTheme: dialogTheme,
    navigationBarTheme: navigationBarThemeData,
  );

  return themeData;
}
