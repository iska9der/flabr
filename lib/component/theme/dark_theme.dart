part of 'theme.dart';

ThemeData darkTheme() {
  var themeData = ThemeData.dark();

  themeData = themeData.copyWith(
    useMaterial3: true,
    cardTheme: buildCardTheme(),
    appBarTheme: buildAppBarTheme().copyWith(shadowColor: Colors.black),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: themeData.colorScheme.background,
    ),
    pageTransitionsTheme: buildPageTransitionsTheme(),
  );

  return themeData;
}
