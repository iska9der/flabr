import 'package:flutter/material.dart';

abstract final class AppFonts {
  static const String fontMaterial = 'Roboto';
  static const String fontGoogle = 'Google';
  static const String fontGeologica = 'Geologica';

  static String get textDefault => fontGoogle;
  static String get titleDefault => fontGeologica;

  static List<String> textFonts = const [
    fontGoogle,
    fontMaterial,
  ];

  static List<String> titleFonts = [
    ...textFonts,
    fontGeologica,
  ];
}

abstract final class AppTypography {
  static TextTheme textTheme({required ColorScheme scheme}) {
    final typography = Typography.material2021(colorScheme: scheme);

    var textTheme = switch (scheme.brightness) {
      .light => typography.black,
      .dark => typography.white,
    }.apply(fontFamily: AppFonts.textDefault);

    textTheme = textTheme.copyWith(
      bodySmall: textTheme.bodySmall!.copyWith(
        fontSize: 12,
        fontWeight: .w400,
      ),
      bodyMedium: textTheme.bodyMedium!.copyWith(
        fontSize: 14,
        fontWeight: .w400,
      ),
      bodyLarge: textTheme.bodyLarge!.copyWith(
        fontSize: 16,
        fontWeight: .w400,
      ),
      labelSmall: textTheme.labelSmall!.copyWith(
        fontSize: 10,
        fontWeight: .w500,
      ),
      labelMedium: textTheme.labelMedium!.copyWith(
        fontSize: 12,
        fontWeight: .w500,
      ),
      labelLarge: textTheme.labelLarge!.copyWith(
        fontSize: 14,
        fontWeight: .w500,
      ),
      titleSmall: textTheme.titleSmall!.copyWith(
        fontWeight: .w500,
        height: 1.1,
      ),
      titleMedium: textTheme.titleMedium!.copyWith(
        fontWeight: .w500,
        height: 1.1,
      ),
      titleLarge: textTheme.titleLarge!.copyWith(
        fontFamily: AppFonts.titleDefault,
        height: 1.1,
      ),
      headlineSmall: textTheme.headlineSmall?.copyWith(
        fontFamily: AppFonts.titleDefault,
        height: 1.1,
      ),
      headlineMedium: textTheme.headlineMedium?.copyWith(
        fontFamily: AppFonts.titleDefault,
        height: 1.1,
      ),
      headlineLarge: textTheme.headlineLarge?.copyWith(
        fontFamily: AppFonts.titleDefault,
        height: 1.1,
      ),
    );

    return textTheme;
  }
}
