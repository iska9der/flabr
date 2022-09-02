import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../config/constants.dart';
import 'constants.dart';

const appCardTheme = CardTheme(
  elevation: 0.8,
  margin: EdgeInsets.symmetric(
    horizontal: kCardMargin,
    vertical: kCardVMargin,
  ),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(kBorderRadiusDefault)),
  ),
);

const AppBarTheme appAppBarTheme = AppBarTheme(
  surfaceTintColor: Colors.transparent,
  elevation: 0,
  scrolledUnderElevation: kScrolledUnderElevation,
  toolbarHeight: kToolBarHeight,
  titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
);

/// issue: https://pub.dev/packages/auto_route#remove-shadow-from-nested-routers
const PageTransitionsTheme appPageTransitionsTheme =
    PageTransitionsTheme(builders: {
  // replace default CupertinoPageTransitionsBuilder with this
  TargetPlatform.iOS: NoShadowCupertinoPageTransitionsBuilder(),
  TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
});

ScrollbarThemeData appScrollBarThemeData = ScrollbarThemeData(
  thumbVisibility: MaterialStateProperty.all(true),
  interactive: true,
  thickness: MaterialStateProperty.all(6),
  minThumbLength: kToolBarHeightOnScroll,
);

TextButtonThemeData appTextButtonThemeData = TextButtonThemeData(
    style: ButtonStyle(
  alignment: Alignment.centerLeft,
  shape: MaterialStateProperty.all<OutlinedBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(
        kBorderRadiusDefault,
      ),
    ),
  ),
));

const DrawerThemeData appDrawerThemeData = DrawerThemeData(width: 200);

const CheckboxThemeData appCheckboxThemeData = CheckboxThemeData();

const SwitchThemeData appSwitchThemeData = SwitchThemeData();

const SliderThemeData appSliderThemeData = SliderThemeData(
  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.0),
  overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0),
);

const ChipThemeData appChipThemeData = ChipThemeData(side: BorderSide.none);
