import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_scheme.dart';
import 'app_typography.dart';
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
    var textTheme = AppTypography.textTheme(scheme: scheme);

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
