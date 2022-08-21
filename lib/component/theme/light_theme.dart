part of 'theme.dart';

ThemeData lightTheme() {
  var themeData = ThemeData.light();

  themeData = themeData.copyWith(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.grey.shade200,
    cardTheme: buildCardTheme(),
    appBarTheme: buildAppBarTheme().copyWith(
      shadowColor: Colors.black87,
      backgroundColor: themeData.scaffoldBackgroundColor,
      titleTextStyle: buildAppBarTheme().titleTextStyle?.copyWith(
            color: Colors.black87,
          ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: themeData.colorScheme.background,
    ),
  );

  return themeData;
}
