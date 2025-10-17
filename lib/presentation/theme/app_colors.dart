import 'package:flutter/material.dart';

abstract class AppColorsLight {
  static const Color surface = Color.fromARGB(255, 240, 240, 240);
  static const Color primary = Color.fromARGB(255, 84, 142, 170);
  static const Color secondary = Color.fromARGB(255, 79, 97, 110);
  static const Color tertiary = Color.fromARGB(255, 44, 136, 255);
  static const Color error = Color(0xFFBA1A1A);
  static const Color disabled = Color.fromARGB(255, 155, 162, 168);

  static const Color card = Color.fromARGB(255, 255, 255, 255);
  static const Color cardHighlight = Color.fromARGB(255, 231, 243, 255);

  static const Color progressTrackColor = Color.fromARGB(76, 18, 141, 241);

  static const Color highlight = Color.fromARGB(255, 122, 166, 0);
  static const Color onHighlight = Color.fromARGB(255, 255, 255, 255);

  static const Color authorColor = Color.fromARGB(255, 236, 247, 223);

  static const Color publicationComplexityLow = Color.fromARGB(
    255,
    71,
    194,
    112,
  );
  static const Color publicationComplexityMedium = Color.fromARGB(
    255,
    73,
    173,
    223,
  );
  static const Color publicationComplexityHight = Color.fromARGB(
    255,
    239,
    108,
    130,
  );

  static const Color sorbus = Color.fromARGB(255, 247, 125, 5);
  static const Color portage = Color.fromARGB(255, 35, 133, 231);
  static const Color mulberry = Color.fromARGB(255, 194, 61, 150);
  static const Color apple = Color.fromARGB(255, 29, 165, 61);
  static const Color deluge = Color.fromARGB(255, 102, 103, 163);
  static const Color scarlet = Color.fromARGB(255, 219, 0, 0);
  static const Color carnation = Color.fromARGB(255, 208, 78, 78);
}

abstract class AppColorsDark {
  static const Color surface = Color.fromARGB(255, 8, 8, 8);
  static const Color primary = Color(0xFF4cb7eb);
  static const Color secondary = Color(0xFFB6C9D8);
  static const Color tertiary = Color(0xFF8ECDFF);
  static const Color error = Color(0xFFFFB4AB);
  static const Color disabled = Color.fromARGB(255, 71, 74, 77);

  static const Color card = Color.fromARGB(255, 23, 23, 23);
  static const Color cardHighlight = Color.fromARGB(255, 26, 51, 77);

  static const Color progressTrackColor = Color.fromARGB(51, 33, 150, 243);

  static const Color highlight = Color.fromARGB(255, 132, 179, 0);
  static const Color onHighlight = Color.fromARGB(255, 23, 23, 23);

  static const Color authorColor = Color.fromARGB(255, 34, 46, 20);

  static const Color publicationComplexityLow = Color.fromARGB(
    255,
    59,
    155,
    91,
  );
  static const Color publicationComplexityMedium = Color.fromARGB(
    255,
    49,
    147,
    196,
  );
  static const Color publicationComplexityHight = Color.fromARGB(
    255,
    201,
    94,
    112,
  );

  static const Color sorbus = Color.fromARGB(255, 255, 159, 64);
  static const Color portage = Color.fromARGB(255, 90, 172, 255);
  static const Color mulberry = Color.fromARGB(255, 224, 100, 183);
  static const Color apple = Color.fromARGB(255, 126, 236, 151);
  static const Color deluge = Color.fromARGB(255, 160, 161, 215);
  static const Color scarlet = Color.fromARGB(255, 244, 118, 118);
  static const Color carnation = Color.fromARGB(255, 255, 115, 115);
}

class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  AppColorsExtension({
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
  });

  final Color surface;
  final Color primary;
  final Color secondary;
  final Color tertiary;
  final Color error;
  final Color disabled;
  final Color card;
  final Color cardHighlight;
  final Color progressTrackColor;
  final Color highlight;
  final Color onHighlight;
  final Color authorColor;
  final Color publicationComplexityLow;
  final Color publicationComplexityMedium;
  final Color publicationComplexityHight;
  final Color sorbus;
  final Color portage;
  final Color mulberry;
  final Color apple;
  final Color deluge;
  final Color scarlet;
  final Color carnation;

  @override
  ThemeExtension<AppColorsExtension> copyWith({
    Color? surface,
    Color? primary,
    Color? secondary,
    Color? tertiary,
    Color? error,
    Color? disabled,
    Color? card,
    Color? cardHighlight,
    Color? progressTrackColor,
    Color? highlight,
    Color? onHighlight,
    Color? authorColor,
    Color? publicationTypePost,
    Color? publicationComplexityLow,
    Color? publicationComplexityMedium,
    Color? publicationComplexityHight,
    Color? sorbus,
    Color? portage,
    Color? mulberry,
    Color? apple,
    Color? deluge,
    Color? scarlet,
    Color? carnation,
  }) {
    return AppColorsExtension(
      surface: surface ?? this.surface,
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      tertiary: tertiary ?? this.tertiary,
      error: error ?? this.error,
      disabled: disabled ?? this.disabled,
      card: card ?? this.card,
      cardHighlight: cardHighlight ?? this.cardHighlight,
      progressTrackColor: progressTrackColor ?? this.progressTrackColor,
      highlight: highlight ?? this.highlight,
      onHighlight: onHighlight ?? this.onHighlight,
      authorColor: authorColor ?? this.authorColor,
      publicationComplexityLow:
          publicationComplexityLow ?? this.publicationComplexityLow,
      publicationComplexityMedium:
          publicationComplexityMedium ?? this.publicationComplexityMedium,
      publicationComplexityHight:
          publicationComplexityHight ?? this.publicationComplexityHight,
      sorbus: sorbus ?? this.sorbus,
      portage: portage ?? this.portage,
      mulberry: mulberry ?? this.mulberry,
      apple: apple ?? this.apple,
      deluge: deluge ?? this.deluge,
      scarlet: scarlet ?? this.scarlet,
      carnation: carnation ?? this.carnation,
    );
  }

  @override
  ThemeExtension<AppColorsExtension> lerp(
    covariant ThemeExtension<AppColorsExtension>? other,
    double t,
  ) {
    if (other is! AppColorsExtension) {
      return this;
    }

    return AppColorsExtension(
      surface: Color.lerp(surface, other.surface, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      tertiary: Color.lerp(tertiary, other.tertiary, t)!,
      error: Color.lerp(error, other.error, t)!,
      disabled: Color.lerp(disabled, other.disabled, t)!,
      card: Color.lerp(card, other.card, t)!,
      cardHighlight: Color.lerp(cardHighlight, other.cardHighlight, t)!,
      progressTrackColor: Color.lerp(
        progressTrackColor,
        other.progressTrackColor,
        t,
      )!,
      highlight: Color.lerp(highlight, other.highlight, t)!,
      onHighlight: Color.lerp(onHighlight, other.onHighlight, t)!,
      authorColor: Color.lerp(authorColor, other.authorColor, t)!,
      publicationComplexityLow: Color.lerp(
        publicationComplexityLow,
        other.publicationComplexityLow,
        t,
      )!,
      publicationComplexityMedium: Color.lerp(
        publicationComplexityMedium,
        other.publicationComplexityMedium,
        t,
      )!,
      publicationComplexityHight: Color.lerp(
        publicationComplexityHight,
        other.publicationComplexityHight,
        t,
      )!,
      sorbus: Color.lerp(sorbus, other.sorbus, t)!,
      portage: Color.lerp(portage, other.portage, t)!,
      mulberry: Color.lerp(mulberry, other.mulberry, t)!,
      apple: Color.lerp(apple, other.apple, t)!,
      deluge: Color.lerp(deluge, other.deluge, t)!,
      scarlet: Color.lerp(scarlet, other.scarlet, t)!,
      carnation: Color.lerp(carnation, other.carnation, t)!,
    );
  }
}
