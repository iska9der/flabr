import 'package:flutter/material.dart';

import '../page/settings/model/config_model.dart';
import 'app_scheme.dart';
import 'app_typography.dart';
import 'common.dart';
import 'extension/app_colors_extension.dart';
import 'extension/app_typography_extension.dart';

abstract class AppTheme {
  static ThemeData light(FeedConfigModel feedConfig) => createThemeData(
    appScheme: AppSchemeLight.scheme,
    appColors: AppSchemeLight.colors,
    feedConfig: feedConfig,
  );

  static ThemeData dark(FeedConfigModel feedConfig) => createThemeData(
    appScheme: AppSchemeDark.scheme,
    appColors: AppSchemeDark.colors,
    feedConfig: feedConfig,
  );

  static ThemeData createThemeData({
    required ColorScheme appScheme,
    required AppColorsExtension appColors,
    FeedConfigModel feedConfig = FeedConfigModel.empty,
  }) {
    var textTheme = AppTypography.textTheme(scheme: appScheme);

    var appTypography = AppTypographyExtension.fromTextTheme(textTheme);
    final titleStyle = feedConfig.titleStyle;
    final descriptionStyle = feedConfig.descriptionStyle;

    appTypography = appTypography.copyWith(
      feedPublicationTitle: appTypography.feedPublicationTitle.copyWith(
        fontFamily: titleStyle?.family,
        fontSize: titleStyle?.size,
        height: titleStyle?.height,
      ),
      feedPublicationDescription: appTypography.feedPublicationDescription
          .copyWith(
            fontFamily: descriptionStyle?.family,
            fontSize: descriptionStyle?.size,
            height: descriptionStyle?.height,
          ),
    );

    var data = ThemeData(
      useMaterial3: true,
      colorScheme: appScheme,
      brightness: appScheme.brightness,
      materialTapTargetSize: .shrinkWrap,
      scaffoldBackgroundColor: appScheme.surface,
      canvasColor: appScheme.surface,
      textTheme: textTheme,
      extensions: [appColors, appTypography],
    );

    data = data.copyWith(
      cardTheme: appCardThemeData,
      appBarTheme: appAppBarThemeData.copyWith(
        backgroundColor: appScheme.surfaceContainer,
        foregroundColor: appScheme.onSurface,
        titleTextStyle: textTheme.titleMedium!.copyWith(
          fontSize: 18,
          color: appScheme.onSurface,
        ),
      ),
      drawerTheme: appDrawerThemeData,
      pageTransitionsTheme: appPageTransitionsTheme,
      scrollbarTheme: appScrollBarThemeData,
      progressIndicatorTheme: proggressIndicatorThemeData,
      textButtonTheme: appTextButtonThemeData,
      iconButtonTheme: IconButtonThemeData(
        style: appIconButtonThemeData,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: appOutlinedButtonStyle.merge(
          OutlinedButton.styleFrom(
            disabledBackgroundColor: appColors.disabled,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: appFilledButtonStyle.merge(
          FilledButton.styleFrom(disabledBackgroundColor: appColors.disabled),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: appElevatedButtonStyle.merge(
          ElevatedButton.styleFrom(disabledBackgroundColor: appColors.disabled),
        ),
      ),
      checkboxTheme: appCheckboxThemeData,
      switchTheme: appSwitchThemeData,
      sliderTheme: appSliderThemeData,
      chipTheme: appChipThemeData,
      dialogTheme: dialogThemeData,
      navigationBarTheme: navigationBarThemeData.copyWith(
        backgroundColor: appScheme.surfaceContainer,
      ),
      bottomSheetTheme: bottomSheetThemeData,
      listTileTheme: listTileThemeData,
    );

    return data;
  }
}
