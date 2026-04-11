// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract class AppSchemeLight {
  static ColorScheme get scheme => ColorScheme.fromSeed(
    // brightness: .light,
    dynamicSchemeVariant: .fidelity,
    contrastLevel: .2,
    seedColor: colors.primary,
    primary: colors.primary,
    secondary: colors.secondary,
    secondaryContainer: colors.primary,
    tertiary: colors.tertiary,
    error: colors.error,
    background: colors.background,
    onBackground: colors.textMain,
    surface: colors.background,
    onSurface: colors.textMain,

    /// цвет карточки [Card]
    surfaceContainerLow: colors.card,

    /// цвет выделенной карточки
    surfaceContainerHighest: colors.cardHighlight,

    /// цвет нижней навигации
    surfaceContainer: const .new(0xFFEAECEF),
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

  static final AppColors colors = AppColors(
    secondary: const .new(0xFF4F616E),
    tertiary: const .new(0xFF2C88FF),
    error: const .new(0xFFBA1A1A),
    disabled: const .new(0xFF9BA2A8),
    sorbus: const .new(0xFFF77D05),
    portage: const .new(0xFF2385E7),
    mulberry: const .new(0xFFC23D96),
    apple: const .new(0xFF1DA53D),
    deluge: const .new(0xFF6667A3),
    scarlet: const .new(0xFFDB0000),
    progressTrackColor: const .new(0x4B128DF1),

    /// NEW colors
    primary: const .new(0xFF548EAA),
    background: const .new(0xFFF0F0F0),
    backgroundSecondary: const .new(0xFFf7f7f7),
    card: const .new(0xFFFFFFFF),
    cardHighlight: const .new(0xFFe5f2ff),
    textMain: const .new(0xFF333333),
    textInactive: const .new(0xFF6F7476),
    textSecondary: const .new(0xFF8f8f8f),
    complexityLow: const .new(0xFF47C270),
    complexityMedium: const .new(0xFF49ADDF),
    complexityHigh: const .new(0xFFEF6C82),
    author: const .new(0xFFecf7de),
    iconColor: const .new(0xFFbcced7),
    iconTextColor: const .new(0xFF929ca5),
    accentPrimary: const .new(0xFF548eab),
    accentPositive: const .new(0xFF7ba800),
    onAccentPositive: const .new(0xFFFFFFFF),
    accentDanger: const .new(0xFFd04e4e),
  );
}

class AppSchemeDark {
  static ColorScheme get scheme => ColorScheme.fromSeed(
    brightness: .dark,
    dynamicSchemeVariant: .fidelity,
    contrastLevel: .2,
    seedColor: colors.primary,
    primary: colors.primary,
    secondary: colors.secondary,
    secondaryContainer: colors.primary,
    tertiary: colors.tertiary,
    error: colors.error,
    background: colors.background,
    onBackground: colors.textMain,
    surface: colors.background,
    onSurface: colors.textMain,
    // surfaceContainer: colors.card.withValues(alpha: .9),
    surfaceContainerLow: colors.card,
    surfaceContainerHighest: colors.cardHighlight,
    onPrimary: const Color(0xFFFFFFFF),
    onPrimaryContainer: const Color(0xFFFFFFFF),
    onSecondary: const Color(0xFFFFFFFF),
    onSecondaryContainer: const Color(0xFFFFFFFF),
    onTertiary: const Color(0xFFFFFFFF),
    onTertiaryContainer: const Color(0xFFFFFFFF),
    onError: const Color(0xFF690005),
    outline: const Color(0xFF8B9198),
  );

  static final AppColors colors = AppColors(
    secondary: const .new(0xFFB6C9D8),
    tertiary: const .new(0xFF8ECDFF),
    error: const .new(0xFFFFB4AB),
    disabled: const .new(0xFF474A4D),
    progressTrackColor: const .fromARGB(51, 33, 150, 243),
    sorbus: const .fromARGB(255, 255, 159, 64),
    portage: const .fromARGB(255, 90, 172, 255),
    mulberry: const .fromARGB(255, 224, 100, 183),
    apple: const .fromARGB(255, 126, 236, 151),
    deluge: const .fromARGB(255, 160, 161, 215),
    scarlet: const .fromARGB(255, 244, 118, 118),

    /// NEW colors
    primary: const .new(0xFF5476AA),
    background: const .new(0xFF080808),
    backgroundSecondary: const .new(0xFF262626),
    card: const .new(0xFF171717),
    cardHighlight: const .new(0xFF19324d),
    textMain: const .new(0xFFDEDEDE),
    textInactive: const .new(0xFFABABAB),
    textSecondary: const .new(0xFFababab),
    complexityLow: const .new(0xFF3B9B5B),
    complexityMedium: const .new(0xFF3193C4),
    complexityHigh: const .new(0xFFC95E70),
    author: const .new(0xFF222E14),
    iconColor: const .new(0xFF6b8694),
    iconTextColor: const .new(0xFF666666),
    accentPrimary: const .new(0xFF4cb6eb),
    accentPositive: const .new(0xFF83b300),
    onAccentPositive: const .new(0xFF171717),
    accentDanger: const .new(0xFFff7575),
  );
}
