import 'package:flutter/material.dart';

part 'dark_theme.dart';
part 'light_theme.dart';

CardTheme buildCardTheme() {
  return const CardTheme(
    elevation: 0.8,
    surfaceTintColor: Colors.transparent,
    margin: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
  );
}

AppBarTheme buildAppBarTheme() {
  return const AppBarTheme(
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    scrolledUnderElevation: 20,
  );
}
