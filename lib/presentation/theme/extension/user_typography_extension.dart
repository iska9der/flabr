import 'package:flutter/material.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

import '../../page/settings/model/config_model.dart';

part 'user_typography_extension.tailor.dart';

@TailorMixin()
class UserTypographyExtension extends ThemeExtension<UserTypographyExtension>
    with _$UserTypographyExtensionTailorMixin {
  UserTypographyExtension({
    required this.publicationTitle,
    required this.publicationText,
  });

  factory UserTypographyExtension.create(
    TextTheme textTheme, [
    TypographyConfigModel? config,
  ]) {
    final titleStyle = config?.titleStyle;
    final textStyle = config?.textStyle;

    return UserTypographyExtension(
      publicationTitle: textTheme.titleLarge!.copyWith(
        fontFamily: titleStyle?.family,
        fontSize: titleStyle?.size ?? 22,
        height: titleStyle?.height ?? 1.1,
      ),
      publicationText: textTheme.bodyLarge!.copyWith(
        fontFamily: textStyle?.family,
        fontSize: textStyle?.size ?? 16,
        height: textStyle?.height ?? 1.2,
      ),
    );
  }

  @override
  final TextStyle publicationTitle;
  @override
  final TextStyle publicationText;
}
