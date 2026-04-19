import 'package:flutter/material.dart';

abstract final class AppTypography {
  static String fontGoogle = 'Google';
  static String fontGeologica = 'Geologica';

  static TextTheme textTheme({required ColorScheme scheme}) {
    final typography = Typography.material2021(colorScheme: scheme);

    var textTheme = switch (scheme.brightness) {
      .light => typography.black,
      .dark => typography.white,
    }.apply(fontFamily: fontGoogle);

    textTheme = textTheme.copyWith(
      bodySmall: textTheme.bodySmall!.copyWith(fontSize: 12),
      bodyMedium: textTheme.bodyMedium!.copyWith(fontSize: 14),
      bodyLarge: textTheme.bodyLarge!.copyWith(fontSize: 16),
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
      titleSmall: textTheme.titleSmall!.copyWith(fontWeight: .w500),
      titleMedium: textTheme.titleMedium!.copyWith(fontWeight: .w500),
      titleLarge: textTheme.titleLarge!.copyWith(fontWeight: .w600),
      headlineSmall: textTheme.headlineSmall?.copyWith(
        fontFamily: fontGeologica,
        fontWeight: .w400,
      ),
      headlineMedium: textTheme.headlineMedium?.copyWith(
        fontFamily: fontGeologica,
        fontWeight: .w500,
      ),
      headlineLarge: textTheme.headlineLarge?.copyWith(
        fontFamily: fontGeologica,
        fontWeight: .w600,
      ),
    );

    return textTheme;
  }
}
