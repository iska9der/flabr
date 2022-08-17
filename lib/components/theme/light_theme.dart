part of 'theme.dart';

ThemeData lightTheme() {
  var themeData = ThemeData.light();

  themeData = themeData.copyWith(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.grey.shade200,
  );

  return themeData;
}
