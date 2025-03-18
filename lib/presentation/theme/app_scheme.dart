// ignore_for_file: deprecated_member_use

part of 'theme.dart';

abstract class LightScheme {
  static const Color surface = Color.fromARGB(255, 240, 240, 240);
  static const Color primary = Color.fromARGB(255, 84, 142, 170);
  static const Color secondary = Color.fromARGB(255, 79, 97, 110);
  static const Color tertiary = Color.fromARGB(255, 44, 136, 255);
  static const Color error = Color(0xFFBA1A1A);

  static ColorScheme get scheme => ColorScheme.fromSeed(
        dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
        contrastLevel: .2,
        seedColor: primary,
        primary: primary,
        secondary: secondary,
        secondaryContainer: primary,
        tertiary: tertiary,
        error: error,

        /// цвет фона
        surface: surface,

        /// цвет выделенной карточки
        surfaceContainerHighest: Color.fromARGB(255, 231, 243, 255),

        /// цвет нижней навигации
        surfaceContainer: Color.fromARGB(255, 234, 236, 239),

        /// цвет карточки [Card]
        surfaceContainerLow: Color.fromARGB(255, 255, 255, 255),
        onPrimary: Color(0xFFFFFFFF),

        /// цвет иконки в FAB
        onPrimaryContainer: Color(0xFFFFFFFF),
        onSecondary: Color(0xFFFFFFFF),

        /// цвет иконки выбранного таба в навигации, текста в выбранном чипе
        onSecondaryContainer: Color(0xFFFFFFFF),
        onTertiary: Color(0xFFFFFFFF),
        onError: Color(0xFFFFFFFF),
        outline: Color(0xFF71787E),
      );
}

class DarkScheme {
  static const Color surface = Color.fromARGB(255, 8, 8, 8);
  static const Color primary = Color(0xFF4cb7eb);
  static const Color secondary = Color(0xFFB6C9D8);
  static const Color tertiary = Color(0xFF8ECDFF);
  static const Color error = Color(0xFFFFB4AB);

  static ColorScheme get scheme => ColorScheme.fromSeed(
        brightness: Brightness.dark,
        dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
        contrastLevel: .2,
        seedColor: primary,
        primary: primary,
        secondary: secondary,
        secondaryContainer: primary,
        tertiary: tertiary,
        error: error,
        surface: surface,
        surfaceContainerHighest: Color.fromARGB(255, 26, 51, 77),
        surfaceContainerLow: Color.fromARGB(255, 23, 23, 23),
        onPrimary: Color(0xFF21323E),
        onPrimaryContainer: Color.fromARGB(255, 67, 74, 78),
        onSecondary: Color(0xFF21323E),
        onSecondaryContainer: Color.fromARGB(255, 67, 74, 78),
        onTertiary: Color(0xFFFFFFFF),
        onTertiaryContainer: Color(0xFFFFFFFF),
        onError: Color(0xFF690005),
        outline: Color(0xFF8B9198),
      );
}
