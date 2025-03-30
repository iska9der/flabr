import 'package:flutter/material.dart';

import 'app_scheme.dart';
import 'common.dart';

abstract class AppTheme {
  static ThemeData get light => theme(
    AppSchemeLight.scheme,
  ).copyWith(extensions: [AppSchemeLight.colors]);

  static ThemeData get dark =>
      theme(AppSchemeDark.scheme).copyWith(extensions: [AppSchemeDark.colors]);

  static ThemeData theme(ColorScheme colorScheme) {
    var typography = Typography.material2021(colorScheme: colorScheme);

    var textTheme = switch (colorScheme.brightness) {
      Brightness.light => typography.black,
      Brightness.dark => typography.white,
    };

    textTheme = textTheme.copyWith(
      titleSmall: textTheme.titleSmall?.copyWith(
        fontFamily: 'Geologica',
        fontVariations: [const FontVariation('wght', 400)],
      ),
      titleMedium: textTheme.titleMedium?.copyWith(
        fontFamily: 'Geologica',
        fontVariations: [const FontVariation('wght', 500)],
      ),
      titleLarge: textTheme.titleLarge?.copyWith(
        fontFamily: 'Geologica',
        fontVariations: [const FontVariation('wght', 600)],
      ),
      headlineSmall: textTheme.headlineSmall?.copyWith(
        fontFamily: 'Geologica',
        fontVariations: [const FontVariation('wght', 400)],
      ),
      headlineMedium: textTheme.headlineMedium?.copyWith(
        fontFamily: 'Geologica',
        fontVariations: [const FontVariation('wght', 500)],
      ),
      headlineLarge: textTheme.headlineLarge?.copyWith(
        fontFamily: 'Geologica',
        fontVariations: [const FontVariation('wght', 600)],
      ),
    );

    var data = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: colorScheme.brightness,
      scaffoldBackgroundColor: colorScheme.surface,
      canvasColor: colorScheme.surface,
      textTheme: textTheme,
    );

    data = data.copyWith(
      cardTheme: appCardTheme,
      appBarTheme: appAppBarTheme.copyWith(
        titleTextStyle: appAppBarTheme.titleTextStyle?.apply(
          color: colorScheme.onSurface,
        ),
      ),
      drawerTheme: appDrawerThemeData,
      pageTransitionsTheme: appPageTransitionsTheme,
      scrollbarTheme: appScrollBarThemeData,
      progressIndicatorTheme: proggressIndicatorThemeData,
      textButtonTheme: appTextButtonThemeData,
      iconButtonTheme: appIconButtonThemeData,
      checkboxTheme: appCheckboxThemeData,
      switchTheme: appSwitchThemeData,
      sliderTheme: appSliderThemeData,
      chipTheme: appChipThemeData,
      dialogTheme: dialogTheme,
      navigationBarTheme: navigationBarThemeData,
      bottomSheetTheme: bottomSheetThemeData,
      listTileTheme: listTileThemeData,
    );

    return data;
  }
}
