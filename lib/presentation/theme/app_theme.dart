part of 'theme.dart';

abstract class AppTheme {
  static ThemeData get light => theme(LightScheme.scheme);
  static ThemeData get dark => theme(DarkScheme.scheme);

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
      headlineSmall: textTheme.headlineSmall?.copyWith(
        fontFamily: 'Geologica',
        fontVariations: [FontVariation('wght', 400)],
      ),
      headlineMedium: textTheme.headlineMedium?.copyWith(
        fontFamily: 'Geologica',
        fontVariations: [FontVariation('wght', 500)],
      ),
      headlineLarge: textTheme.headlineLarge?.copyWith(
        fontFamily: 'Geologica',
        fontVariations: [FontVariation('wght', 600)],
      ),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: colorScheme.brightness,
      scaffoldBackgroundColor: colorScheme.surface,
      canvasColor: colorScheme.surface,
      textTheme: textTheme,
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
