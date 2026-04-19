import 'package:flutter/material.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part 'app_colors.tailor.dart';

@TailorMixin()
class AppColors extends ThemeExtension<AppColors> with _$AppColorsTailorMixin {
  AppColors({
    required this.secondary,
    required this.tertiary,
    required this.error,
    required this.disabled,
    required this.progressTrackColor,
    required this.sorbus,
    required this.portage,
    required this.mulberry,
    required this.apple,
    required this.deluge,
    required this.scarlet,
    required this.primary,
    required this.background,
    required this.backgroundSecondary,
    required this.card,
    required this.cardHighlight,
    required this.textMain,
    required this.textInactive,
    required this.textSecondary,
    required this.author,
    required this.complexityLow,
    required this.complexityMedium,
    required this.complexityHigh,
    required this.iconColor,
    required this.iconTextColor,
    required this.accentPrimary,
    required this.accentPositive,
    required this.onAccentPositive,
    required this.accentDanger,
  });

  @override
  final Color secondary;
  @override
  final Color tertiary;
  @override
  final Color error;
  @override
  final Color disabled;
  @override
  final Color progressTrackColor;
  @override
  final Color sorbus;
  @override
  final Color portage;
  @override
  final Color mulberry;
  @override
  final Color apple;
  @override
  final Color deluge;
  @override
  final Color scarlet;

  @override
  final Color primary;
  @override
  final Color background;
  @override
  final Color backgroundSecondary;
  @override
  final Color card;
  @override
  final Color cardHighlight;
  @override
  final Color textMain;
  @override
  final Color textInactive;
  @override
  final Color textSecondary;
  @override
  final Color complexityLow;
  @override
  final Color complexityMedium;
  @override
  final Color complexityHigh;
  @override
  final Color author;
  @override
  final Color iconColor;
  @override
  final Color iconTextColor;
  @override
  final Color accentPrimary;
  @override
  final Color accentPositive;
  @override
  final Color onAccentPositive;
  @override
  final Color accentDanger;
}
