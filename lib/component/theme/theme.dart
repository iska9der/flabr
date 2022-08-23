import 'package:auto_route/auto_route.dart';
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
    toolbarHeight: 60,
    titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
  );
}

/// issue: https://pub.dev/packages/auto_route#remove-shadow-from-nested-routers
PageTransitionsTheme buildPageTransitionsTheme() {
  return const PageTransitionsTheme(builders: {
    // replace default CupertinoPageTransitionsBuilder with this
    TargetPlatform.iOS: NoShadowCupertinoPageTransitionsBuilder(),
    TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
  });
}
