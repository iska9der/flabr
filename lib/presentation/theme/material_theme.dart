// ignore_for_file: deprecated_member_use

part of 'theme.dart';

abstract class MaterialTheme {
  static ColorScheme lightScheme() {
    const Color primary = Color(0xFF00658F);

    return const ColorScheme(
      brightness: Brightness.light,
      background: Color.fromARGB(255, 240, 240, 240),
      primary: primary,
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
      surface: Color.fromARGB(255, 251, 251, 251),
      surfaceContainerHigh: Color.fromARGB(255, 249, 249, 249),
      surfaceContainerHighest: Color.fromARGB(255, 247, 247, 247),
      surfaceContainerLow: Color.fromARGB(255, 253, 253, 253),
      surfaceContainerLowest: Color.fromARGB(255, 255, 255, 255),
      onSurface: Color.fromARGB(255, 20, 20, 20),
      surfaceTint: Color(0xFFF8FDFF),
      onSurfaceVariant: Color.fromARGB(255, 32, 34, 36),
      outline: Color(0xFF71787E),
      outlineVariant: Color(0xFFC1C7CE),
      onInverseSurface: Color(0xFFD6F6FF),
      inverseSurface: Color(0xFF00363F),
      inversePrimary: Color(0xFF86CFFF),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
    );
  }

  static ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme darkScheme() {
    const Color primary = Color(0xFF86CFFF);

    return const ColorScheme(
      brightness: Brightness.dark,
      background: Color.fromARGB(255, 20, 20, 20),
      primary: primary,
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
      surfaceTint: primary,
      onSurfaceVariant: Color(0xFFC1C7CE),
      outline: Color(0xFF8B9198),
      outlineVariant: Color(0xFF41484D),
      onInverseSurface: Color(0xFF001F25),
      inverseSurface: Color(0xFFA6EEFF),
      inversePrimary: Color(0xFF00658F),
      shadow: Color.fromARGB(255, 20, 20, 20),
      scrim: Color.fromARGB(255, 20, 20, 20),
    );
  }

  static ThemeData dark() {
    return theme(darkScheme());
  }

  static ThemeData theme(ColorScheme colorScheme) {
    var typography = Typography.material2021(colorScheme: colorScheme);

    var textTheme = switch (colorScheme.brightness) {
      Brightness.light => typography.black,
      Brightness.dark => typography.white,
    };

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

    return ThemeData(
      useMaterial3: true,
      brightness: colorScheme.brightness,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: colorScheme.background,
      canvasColor: colorScheme.surface,
      cardTheme: appCardTheme,
      appBarTheme: appAppBarTheme.copyWith(
        titleTextStyle: appAppBarTheme.titleTextStyle?.apply(
          color: colorScheme.onSurface,
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
  }
}
