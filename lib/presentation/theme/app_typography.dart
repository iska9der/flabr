import 'package:flutter/material.dart';

abstract final class AppTypography {
  static TextTheme textTheme({required ColorScheme scheme}) {
    final typography = Typography.material2021(colorScheme: scheme);

    var textTheme = switch (scheme.brightness) {
      .light => typography.black,
      .dark => typography.white,
    };

    textTheme = textTheme.copyWith(
      titleSmall: textTheme.titleSmall?.copyWith(
        fontFamily: 'Geologica',
        fontWeight: .w400,
      ),
      titleMedium: textTheme.titleMedium?.copyWith(
        fontFamily: 'Geologica',
        fontWeight: .w500,
      ),
      titleLarge: textTheme.titleLarge?.copyWith(
        fontFamily: 'Geologica',
        fontWeight: .w600,
      ),
      headlineSmall: textTheme.headlineSmall?.copyWith(
        fontFamily: 'Geologica',
        fontWeight: .w400,
      ),
      headlineMedium: textTheme.headlineMedium?.copyWith(
        fontFamily: 'Geologica',
        fontWeight: .w500,
      ),
      headlineLarge: textTheme.headlineLarge?.copyWith(
        fontFamily: 'Geologica',
        fontWeight: .w600,
      ),
    );

    return textTheme;
  }
}
