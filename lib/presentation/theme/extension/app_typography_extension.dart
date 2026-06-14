import 'package:flutter/material.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part 'app_typography_extension.tailor.dart';

@TailorMixin()
class AppTypographyExtension extends ThemeExtension<AppTypographyExtension>
    with _$AppTypographyExtensionTailorMixin {
  AppTypographyExtension({
    required this.feedPublicationTitle,
  });

  factory AppTypographyExtension.fromTextTheme(TextTheme textTheme) {
    return AppTypographyExtension(
      feedPublicationTitle: textTheme.titleLarge!.copyWith(
        fontSize: 22,
        height: 1,
      ),
    );
  }

  @override
  final TextStyle feedPublicationTitle;
}
