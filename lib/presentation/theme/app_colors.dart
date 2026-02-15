import 'package:flutter/material.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part 'app_colors.tailor.dart';

@TailorMixin()
class AppColors extends ThemeExtension<AppColors> with _$AppColorsTailorMixin {
  AppColors({
    required this.surface,
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.error,
    required this.disabled,
    required this.card,
    required this.cardHighlight,
    required this.progressTrackColor,
    required this.highlight,
    required this.onHighlight,
    required this.authorColor,
    required this.publicationComplexityLow,
    required this.publicationComplexityMedium,
    required this.publicationComplexityHight,
    required this.sorbus,
    required this.portage,
    required this.mulberry,
    required this.apple,
    required this.deluge,
    required this.scarlet,
    required this.carnation,
    required this.shady,
  });

  @override
  final Color surface;
  @override
  final Color primary;
  @override
  final Color secondary;
  @override
  final Color tertiary;
  @override
  final Color error;
  @override
  final Color disabled;
  @override
  final Color card;
  @override
  final Color cardHighlight;
  @override
  final Color progressTrackColor;
  @override
  final Color highlight;
  @override
  final Color onHighlight;
  @override
  final Color authorColor;
  @override
  final Color publicationComplexityLow;
  @override
  final Color publicationComplexityMedium;
  @override
  final Color publicationComplexityHight;
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
  final Color carnation;
  @override
  final Color shady;
}

abstract class AppColorsLight {
  static const Color surface = .fromARGB(255, 240, 240, 240);
  static const Color primary = .fromARGB(255, 84, 142, 170);
  static const Color secondary = .fromARGB(255, 79, 97, 110);
  static const Color tertiary = .fromARGB(255, 44, 136, 255);
  static const Color error = Color(0xFFBA1A1A);
  static const Color disabled = .fromARGB(255, 155, 162, 168);

  static const Color card = .fromARGB(255, 255, 255, 255);
  static const Color cardHighlight = .fromARGB(255, 231, 243, 255);

  static const Color progressTrackColor = .fromARGB(76, 18, 141, 241);

  static const Color highlight = .fromARGB(255, 122, 166, 0);
  static const Color onHighlight = .fromARGB(255, 255, 255, 255);

  static const Color authorColor = .fromARGB(255, 236, 247, 223);

  static const Color publicationComplexityLow = .fromARGB(255, 71, 194, 112);
  static const Color publicationComplexityMedium = .fromARGB(255, 73, 173, 223);
  static const Color publicationComplexityHight = .fromARGB(255, 239, 108, 130);

  static const Color sorbus = .fromARGB(255, 247, 125, 5);
  static const Color portage = .fromARGB(255, 35, 133, 231);
  static const Color mulberry = .fromARGB(255, 194, 61, 150);
  static const Color apple = .fromARGB(255, 29, 165, 61);
  static const Color deluge = .fromARGB(255, 102, 103, 163);
  static const Color scarlet = .fromARGB(255, 219, 0, 0);
  static const Color carnation = .fromARGB(255, 208, 78, 78);
  static const Color shady = .fromARGB(255, 170, 170, 170);
}

abstract class AppColorsDark {
  static const Color surface = .fromARGB(255, 8, 8, 8);
  static const Color primary = Color(0xFF4cb7eb);
  static const Color secondary = Color(0xFFB6C9D8);
  static const Color tertiary = Color(0xFF8ECDFF);
  static const Color error = Color(0xFFFFB4AB);
  static const Color disabled = .fromARGB(255, 71, 74, 77);

  static const Color card = .fromARGB(255, 23, 23, 23);
  static const Color cardHighlight = .fromARGB(255, 26, 51, 77);

  static const Color progressTrackColor = .fromARGB(51, 33, 150, 243);

  static const Color highlight = .fromARGB(255, 132, 179, 0);
  static const Color onHighlight = .fromARGB(255, 23, 23, 23);

  static const Color authorColor = .fromARGB(255, 34, 46, 20);

  static const Color publicationComplexityLow = .fromARGB(255, 59, 155, 91);
  static const Color publicationComplexityMedium = .fromARGB(255, 49, 147, 196);
  static const Color publicationComplexityHight = .fromARGB(255, 201, 94, 112);

  static const Color sorbus = .fromARGB(255, 255, 159, 64);
  static const Color portage = .fromARGB(255, 90, 172, 255);
  static const Color mulberry = .fromARGB(255, 224, 100, 183);
  static const Color apple = .fromARGB(255, 126, 236, 151);
  static const Color deluge = .fromARGB(255, 160, 161, 215);
  static const Color scarlet = .fromARGB(255, 244, 118, 118);
  static const Color carnation = .fromARGB(255, 255, 115, 115);
  static const Color shady = .fromARGB(255, 170, 170, 170);
}
