import 'package:flutter/material.dart';

abstract class AppColorsLight {
  static const Color surface = Color.fromARGB(255, 240, 240, 240);
  static const Color primary = Color.fromARGB(255, 84, 142, 170);
  static const Color secondary = Color.fromARGB(255, 79, 97, 110);
  static const Color tertiary = Color.fromARGB(255, 44, 136, 255);
  static const Color error = Color(0xFFBA1A1A);

  static const Color card = Color.fromARGB(255, 255, 255, 255);
  static const Color cardHighlight = Color.fromARGB(255, 231, 243, 255);

  static const Color progressTrackColor = Color.fromARGB(76, 18, 141, 241);

  static final extension = AppColorsExtension(
    surface: surface,
    primary: primary,
    secondary: secondary,
    tertiary: tertiary,
    error: error,
    card: card,
    cardHighlight: cardHighlight,
    progressTrackColor: progressTrackColor,
  );
}

abstract class AppColorsDark {
  static const Color surface = Color.fromARGB(255, 8, 8, 8);
  static const Color primary = Color(0xFF4cb7eb);
  static const Color secondary = Color(0xFFB6C9D8);
  static const Color tertiary = Color(0xFF8ECDFF);
  static const Color error = Color(0xFFFFB4AB);

  static const Color card = Color.fromARGB(255, 23, 23, 23);
  static const Color cardHighlight = Color.fromARGB(255, 26, 51, 77);

  static const Color progressTrackColor = Color.fromARGB(51, 33, 150, 243);

  static final extension = AppColorsExtension(
    surface: surface,
    primary: primary,
    secondary: secondary,
    tertiary: tertiary,
    error: error,
    card: card,
    cardHighlight: cardHighlight,
    progressTrackColor: progressTrackColor,
  );
}

class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  AppColorsExtension({
    required this.surface,
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.error,
    required this.card,
    required this.cardHighlight,
    required this.progressTrackColor,
  });

  final Color surface;
  final Color primary;
  final Color secondary;
  final Color tertiary;
  final Color error;
  final Color card;
  final Color cardHighlight;
  final Color progressTrackColor;

  @override
  ThemeExtension<AppColorsExtension> copyWith({
    Color? surface,
    Color? primary,
    Color? secondary,
    Color? tertiary,
    Color? error,
    Color? card,
    Color? cardHighlight,
    Color? progressTrackColor,
  }) {
    return AppColorsExtension(
      surface: surface ?? this.surface,
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      tertiary: tertiary ?? this.tertiary,
      error: error ?? this.error,
      card: card ?? this.card,
      cardHighlight: cardHighlight ?? this.cardHighlight,
      progressTrackColor: progressTrackColor ?? this.progressTrackColor,
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
      card: Color.lerp(card, other.card, t)!,
      cardHighlight: Color.lerp(cardHighlight, other.cardHighlight, t)!,
      progressTrackColor:
          Color.lerp(progressTrackColor, other.progressTrackColor, t)!,
    );
  }
}
