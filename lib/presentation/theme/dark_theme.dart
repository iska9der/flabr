part of 'part.dart';

const _darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF86CFFF),
  onPrimary: Color(0xFF00344C),
  primaryContainer: Color(0xFF004C6D),
  onPrimaryContainer: Color(0xFFC7E7FF),
  secondary: Color(0xFFB6C9D8),
  onSecondary: Color(0xFF21323E),
  secondaryContainer: Color(0xFF384956),
  onSecondaryContainer: Color(0xFFD2E5F5),
  tertiary: Color(0xFF8ECDFF),
  onTertiary: Color(0xFF00344F),
  tertiaryContainer: Color(0xFF004B70),
  onTertiaryContainer: Color(0xFFCAE6FF),
  error: Color(0xFFFFB4AB),
  errorContainer: Color(0xFF93000A),
  onError: Color(0xFF690005),
  onErrorContainer: Color(0xFFFFDAD6),
  surface: Color.fromARGB(255, 35, 35, 35),
  onSurface: Color(0xFFA6EEFF),
  surfaceContainerHighest: Color(0xFF41484D),
  onSurfaceVariant: Color(0xFFC1C7CE),
  outline: Color(0xFF8B9198),
  onInverseSurface: Color(0xFF001F25),
  inverseSurface: Color(0xFFA6EEFF),
  inversePrimary: Color(0xFF00658F),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFF86CFFF),
  outlineVariant: Color(0xFF41484D),
  scrim: Color(0xFF000000),
);

ThemeData darkTheme() {
  var themeData = ThemeData.dark();

  themeData = themeData.copyWith(
    colorScheme: _darkColorScheme,
    cardTheme: appCardTheme,
    appBarTheme: appAppBarTheme,
    drawerTheme: appDrawerThemeData,
    pageTransitionsTheme: appPageTransitionsTheme,
    scrollbarTheme: appScrollBarThemeData,
    textButtonTheme: appTextButtonThemeData,
    iconButtonTheme: appIconButtonThemeData,
    sliderTheme: appSliderThemeData,
    chipTheme: appChipThemeData,
    checkboxTheme: appCheckboxThemeData,
    switchTheme: appSwitchThemeData,
    dialogTheme: dialogTheme,
    navigationBarTheme: navigationBarThemeData,
    bottomSheetTheme: bottomSheetThemeData,
  );

  return themeData;
}
