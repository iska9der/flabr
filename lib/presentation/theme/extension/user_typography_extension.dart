import 'package:flutter/material.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part 'user_typography_extension.tailor.dart';

@TailorMixin()
class UserTypographyExtension extends ThemeExtension<UserTypographyExtension>
    with _$UserTypographyExtensionTailorMixin {
  UserTypographyExtension({
    required this.feedPublicationTitle,
    required this.feedPublicationDescription,
    required this.publicationText,
  });

  factory UserTypographyExtension.fromTextTheme(TextTheme textTheme) {
    return UserTypographyExtension(
      feedPublicationTitle: textTheme.titleLarge!.copyWith(
        fontSize: 22,
        height: 1.1,
      ),
      feedPublicationDescription: textTheme.bodyLarge!.copyWith(
        fontSize: 16,
        height: 1.2,
      ),
      publicationText: textTheme.bodyLarge!.copyWith(
        fontSize: 16,
        height: 1.2,
      ),
    );
  }

  @override
  final TextStyle feedPublicationTitle;
  @override
  final TextStyle feedPublicationDescription;
  @override
  final TextStyle publicationText;
}
