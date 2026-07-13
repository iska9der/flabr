import 'package:flutter/material.dart';

import '../page/settings/model/config_model.dart';
import 'app_scheme.dart';
import 'app_typography.dart';
import 'common.dart';
import 'extension/app_colors_extension.dart';
import 'extension/user_typography_extension.dart';

abstract class AppTheme {
  static ThemeData light({
    FeedConfigModel feedConfig = FeedConfigModel.empty,
    PublicationConfigModel publicationConfig = PublicationConfigModel.empty,
  }) => createThemeData(
    appScheme: AppSchemeLight.scheme,
    appColors: AppSchemeLight.colors,
    feedConfig: feedConfig,
    publicationConfig: publicationConfig,
  );

  static ThemeData dark({
    FeedConfigModel feedConfig = FeedConfigModel.empty,
    PublicationConfigModel publicationConfig = PublicationConfigModel.empty,
  }) => createThemeData(
    appScheme: AppSchemeDark.scheme,
    appColors: AppSchemeDark.colors,
    feedConfig: feedConfig,
    publicationConfig: publicationConfig,
  );

  static ThemeData createThemeData({
    required ColorScheme appScheme,
    required AppColorsExtension appColors,
    FeedConfigModel feedConfig = FeedConfigModel.empty,
    PublicationConfigModel publicationConfig = PublicationConfigModel.empty,
  }) {
    var textTheme = AppTypography.textTheme(scheme: appScheme);

    var userTypography = UserTypographyExtension.fromTextTheme(textTheme);
    final titleStyle = feedConfig.titleStyle;
    final descriptionStyle = feedConfig.descriptionStyle;

    userTypography = userTypography.copyWith(
      feedPublicationTitle: userTypography.feedPublicationTitle.copyWith(
        fontFamily: titleStyle?.family,
        fontSize: titleStyle?.size,
        height: titleStyle?.height,
      ),
      feedPublicationDescription: userTypography.feedPublicationDescription
          .copyWith(
            fontFamily: descriptionStyle?.family,
            fontSize: descriptionStyle?.size,
            height: descriptionStyle?.height,
          ),
      publicationText: userTypography.publicationText.copyWith(
        fontFamily: publicationConfig.textStyle?.family,
        fontSize: publicationConfig.textStyle?.size,
        height: publicationConfig.textStyle?.height,
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
      extensions: [appColors, userTypography],
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
