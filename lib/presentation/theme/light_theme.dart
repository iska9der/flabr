part of 'part.dart';

const _lightColorScheme = ColorScheme(
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
  surface: Color.fromARGB(255, 255, 255, 255),
  onSurface: Color(0xFF001F25),
  surfaceTint: Color(0xFFF8FDFF),
  surfaceContainerHighest: Color(0xFFDDE3EA),
  onSurfaceVariant: Color.fromARGB(255, 32, 34, 36),
  outline: Color(0xFF71787E),
  onInverseSurface: Color(0xFFD6F6FF),
  inverseSurface: Color(0xFF00363F),
  inversePrimary: Color(0xFF86CFFF),
  shadow: Color(0xFF000000),
  outlineVariant: Color(0xFFC1C7CE),
  scrim: Color(0xFF000000),
);

ThemeData lightTheme() {
  final colorScheme = _lightColorScheme;

  var textTheme = Typography.material2021(colorScheme: colorScheme).black;
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

  var bgColor = Color.fromARGB(255, 240, 240, 240);
  themeData = themeData.copyWith(
    scaffoldBackgroundColor: bgColor,
    cardTheme: appCardTheme,
    appBarTheme: appAppBarTheme.copyWith(
      titleTextStyle: appAppBarTheme.titleTextStyle?.copyWith(
        color: Colors.black87,
      ),
    ),
    drawerTheme: appDrawerThemeData,
    pageTransitionsTheme: appPageTransitionsTheme,
    scrollbarTheme: appScrollBarThemeData,
    textButtonTheme: appTextButtonThemeData,
    iconButtonTheme: appIconButtonThemeData,
    checkboxTheme: appCheckboxThemeData,
    switchTheme: appSwitchThemeData,
    sliderTheme: appSliderThemeData,
    chipTheme: appChipThemeData,
    dialogTheme: dialogTheme,
    navigationBarTheme: navigationBarThemeData,
    bottomSheetTheme: bottomSheetThemeData,
  );

  return themeData;
}
