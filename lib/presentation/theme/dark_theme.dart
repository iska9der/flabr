part of 'part.dart';

const Color _darkPrimary = Color(0xFF86CFFF);

const _darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: _darkPrimary,
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
  surfaceContainerHigh: Color.fromARGB(255, 33, 33, 33),
  surfaceContainerHighest: Color.fromARGB(255, 31, 31, 31),
  surfaceContainerLow: Color.fromARGB(255, 37, 37, 37),
  surfaceContainerLowest: Color.fromARGB(255, 39, 39, 39),
  onSurface: Color.fromARGB(255, 255, 255, 255),
  surfaceTint: _darkPrimary,
  onSurfaceVariant: Color(0xFFC1C7CE),
  outline: Color(0xFF8B9198),
  outlineVariant: Color(0xFF41484D),
  onInverseSurface: Color(0xFF001F25),
  inverseSurface: Color(0xFFA6EEFF),
  inversePrimary: Color(0xFF00658F),
  shadow: Color.fromARGB(255, 20, 20, 20),
  scrim: Color.fromARGB(255, 20, 20, 20),
);

ThemeData darkTheme() {
  final colorScheme = _darkColorScheme;

  var textTheme = Typography.material2021(colorScheme: colorScheme).white;
  textTheme = textTheme.copyWith(
    titleSmall: textTheme.titleSmall?.copyWith(
      fontFamily: 'Geologica',
      fontVariations: [FontVariation('wght', 400)],
    ),
    titleMedium: textTheme.titleMedium?.copyWith(
      fontFamily: 'Geologica',
      fontVariations: [FontVariation('wght', 500)],
    ),
    titleLarge: textTheme.titleLarge?.copyWith(
      fontFamily: 'Geologica',
      fontVariations: [FontVariation('wght', 600)],
    ),
  );

  var themeData = ThemeData.from(
    colorScheme: colorScheme,
    textTheme: textTheme,
  );

  var bgColor = Color.fromARGB(255, 20, 20, 20);
  themeData = themeData.copyWith(
    scaffoldBackgroundColor: bgColor,
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
