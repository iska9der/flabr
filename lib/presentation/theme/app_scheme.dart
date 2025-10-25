// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract class AppSchemeLight {
  static final AppColorsExtension colors = AppColorsExtension(
    surface: AppColorsLight.surface,
    primary: AppColorsLight.primary,
    secondary: AppColorsLight.secondary,
    tertiary: AppColorsLight.tertiary,
    error: AppColorsLight.error,
    disabled: AppColorsLight.disabled,
    card: AppColorsLight.card,
    cardHighlight: AppColorsLight.cardHighlight,
    progressTrackColor: AppColorsLight.progressTrackColor,
    highlight: AppColorsLight.highlight,
    onHighlight: AppColorsLight.onHighlight,
    authorColor: AppColorsLight.authorColor,
    publicationComplexityLow: AppColorsLight.publicationComplexityLow,
    publicationComplexityMedium: AppColorsLight.publicationComplexityMedium,
    publicationComplexityHight: AppColorsLight.publicationComplexityHight,
    sorbus: AppColorsLight.sorbus,
    portage: AppColorsLight.portage,
    mulberry: AppColorsLight.mulberry,
    apple: AppColorsLight.apple,
    deluge: AppColorsLight.deluge,
    scarlet: AppColorsLight.scarlet,
    carnation: AppColorsLight.carnation,
    shady: AppColorsLight.shady,
  );

  static ColorScheme get scheme => ColorScheme.fromSeed(
    dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
    contrastLevel: .2,
    seedColor: colors.primary,
    primary: colors.primary,
    secondary: colors.secondary,
    secondaryContainer: colors.primary,
    tertiary: colors.tertiary,
    error: colors.error,
    background: colors.surface,
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
  static final AppColorsExtension colors = AppColorsExtension(
    surface: AppColorsDark.surface,
    primary: AppColorsDark.primary,
    secondary: AppColorsDark.secondary,
    tertiary: AppColorsDark.tertiary,
    error: AppColorsDark.error,
    disabled: AppColorsDark.disabled,
    card: AppColorsDark.card,
    cardHighlight: AppColorsDark.cardHighlight,
    progressTrackColor: AppColorsDark.progressTrackColor,
    highlight: AppColorsDark.highlight,
    onHighlight: AppColorsDark.onHighlight,
    authorColor: AppColorsDark.authorColor,
    publicationComplexityLow: AppColorsDark.publicationComplexityLow,
    publicationComplexityMedium: AppColorsDark.publicationComplexityMedium,
    publicationComplexityHight: AppColorsDark.publicationComplexityHight,
    sorbus: AppColorsDark.sorbus,
    portage: AppColorsDark.portage,
    mulberry: AppColorsDark.mulberry,
    apple: AppColorsDark.apple,
    deluge: AppColorsDark.deluge,
    scarlet: AppColorsDark.scarlet,
    carnation: AppColorsDark.carnation,
    shady: AppColorsDark.shady,
  );

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
    background: colors.surface,
    surface: colors.surface,
    surfaceContainerLow: colors.card,
    surfaceContainerHighest: colors.cardHighlight,
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
