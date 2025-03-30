// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract class AppSchemeLight {
  static AppColorsExtension get colors => AppColorsLight.extension;

  static ColorScheme get scheme => ColorScheme.fromSeed(
    dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
    contrastLevel: .2,
    seedColor: colors.primary,
    primary: colors.primary,
    secondary: colors.secondary,
    secondaryContainer: colors.primary,
    tertiary: colors.tertiary,
    error: colors.error,
    surface: colors.surface,

    /// цвет карточки [Card]
    surfaceContainerLow: colors.card,

    /// цвет выделенной карточки
    surfaceContainerHighest: colors.cardHighlight,

    /// цвет нижней навигации
    surfaceContainer: const Color.fromARGB(255, 234, 236, 239),
    onPrimary: const Color(0xFFFFFFFF),

    /// цвет иконки в FAB
    onPrimaryContainer: const Color(0xFFFFFFFF),
    onSecondary: const Color(0xFFFFFFFF),

    /// цвет иконки выбранного таба в навигации, текста в выбранном чипе
    onSecondaryContainer: const Color(0xFFFFFFFF),
    onTertiary: const Color(0xFFFFFFFF),
    onError: const Color(0xFFFFFFFF),
    outline: const Color(0xFF71787E),
  );
}

class AppSchemeDark {
  static AppColorsExtension get colors => AppColorsDark.extension;

  static ColorScheme get scheme => ColorScheme.fromSeed(
    brightness: Brightness.dark,
    dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
    contrastLevel: .2,
    seedColor: colors.primary,
    primary: colors.primary,
    secondary: colors.secondary,
    secondaryContainer: colors.primary,
    tertiary: colors.tertiary,
    error: colors.error,
    surface: colors.surface,
    surfaceContainerHighest: colors.cardHighlight,
    surfaceContainerLow: colors.card,
    onPrimary: const Color(0xFF21323E),
    onPrimaryContainer: const Color.fromARGB(255, 67, 74, 78),
    onSecondary: const Color(0xFF21323E),
    onSecondaryContainer: const Color.fromARGB(255, 67, 74, 78),
    onTertiary: const Color(0xFFFFFFFF),
    onTertiaryContainer: const Color(0xFFFFFFFF),
    onError: const Color(0xFF690005),
    outline: const Color(0xFF8B9198),
  );
}
