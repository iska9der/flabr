part of 'theme.dart';

ThemeData darkTheme() {
  var themeData = ThemeData.dark();

  themeData = themeData.copyWith(
    useMaterial3: true,
  );

  return themeData;
}
