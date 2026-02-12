import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_scheme.dart';
import 'common.dart';

abstract class AppTheme {
  static ThemeData get light => createThemeData(
    scheme: AppSchemeLight.scheme,
    colors: AppSchemeLight.colors,
  );

  static ThemeData get dark => createThemeData(
    scheme: AppSchemeDark.scheme,
    colors: AppSchemeDark.colors,
  );

  static ThemeData createThemeData({
    required ColorScheme scheme,
    required AppColors colors,
  }) {
    var typography = Typography.material2021(colorScheme: scheme);

    var textTheme = switch (scheme.brightness) {
      Brightness.light => typography.black,
      Brightness.dark => typography.white,
    };

    textTheme = textTheme.copyWith(
      titleSmall: textTheme.titleSmall?.copyWith(
        fontFamily: 'Geologica',
        fontVariations: [const FontVariation.weight(400)],
      ),
      titleMedium: textTheme.titleMedium?.copyWith(
        fontFamily: 'Geologica',
        fontVariations: [const FontVariation.weight(500)],
      ),
      titleLarge: textTheme.titleLarge?.copyWith(
        fontFamily: 'Geologica',
        fontVariations: [const FontVariation.weight(600)],
      ),
      headlineSmall: textTheme.headlineSmall?.copyWith(
        fontFamily: 'Geologica',
        fontVariations: [const FontVariation.weight(400)],
      ),
      headlineMedium: textTheme.headlineMedium?.copyWith(
        fontFamily: 'Geologica',
        fontVariations: [const FontVariation.weight(500)],
      ),
      headlineLarge: textTheme.headlineLarge?.copyWith(
        fontFamily: 'Geologica',
        fontVariations: [const FontVariation.weight(600)],
      ),
    );

    var data = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      brightness: scheme.brightness,
      scaffoldBackgroundColor: scheme.surface,
      canvasColor: scheme.surface,
      textTheme: textTheme,
      extensions: [colors],
    );

    data = data.copyWith(
      cardTheme: appCardTheme,
      appBarTheme: appAppBarTheme.copyWith(
        titleTextStyle: appAppBarTheme.titleTextStyle?.apply(
          color: scheme.onSurface,
        ),
      ),
      drawerTheme: appDrawerThemeData,
      pageTransitionsTheme: appPageTransitionsTheme,
      scrollbarTheme: appScrollBarThemeData,
      progressIndicatorTheme: proggressIndicatorThemeData,
      textButtonTheme: appTextButtonThemeData,
      iconButtonTheme: appIconButtonThemeData,
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: appOutlinedButtonStyle.merge(
          OutlinedButton.styleFrom(
            disabledBackgroundColor: colors.disabled,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: appFilledButtonStyle.merge(
          FilledButton.styleFrom(disabledBackgroundColor: colors.disabled),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: appElevatedButtonStyle.merge(
          ElevatedButton.styleFrom(disabledBackgroundColor: colors.disabled),
        ),
      ),
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
