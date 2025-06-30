import 'package:flutter/material.dart';

import 'constants.dart';
import 'responsive.dart';

const appCardTheme = CardThemeData(
  elevation: 1,
  margin: AppInsets.cardMargin,
  shape: RoundedRectangleBorder(borderRadius: AppStyles.borderRadius),
);

const appAppBarTheme = AppBarTheme(
  surfaceTintColor: Colors.transparent,
  elevation: 0,
  scrolledUnderElevation: AppDimensions.underElevation,
  toolbarHeight: AppDimensions.toolBarHeight,
  titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
);

const appPageTransitionsTheme = PageTransitionsTheme(
  builders: {
    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
    // не корректно работает, возможно проблема с auto_route
    // TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
  },
);

final appScrollBarThemeData = ScrollbarThemeData(
  thumbVisibility: WidgetStateProperty.all(false),
  interactive: true,
  thickness: WidgetStateProperty.all(6),
  minThumbLength: AppDimensions.toolBarHeightOnScroll,
);

final appTextButtonThemeData = TextButtonThemeData(
  style: TextButton.styleFrom(
    shape: const RoundedRectangleBorder(borderRadius: AppStyles.borderRadius),
  ),
);

final appIconButtonThemeData = IconButtonThemeData(
  style: IconButton.styleFrom(
    shape: const RoundedRectangleBorder(borderRadius: AppStyles.borderRadius),
  ),
);

final appFilledButtonStyle = FilledButton.styleFrom(
  shape: const RoundedRectangleBorder(borderRadius: AppStyles.borderRadius),
);

const appDrawerThemeData = DrawerThemeData(width: 200);

const appCheckboxThemeData = CheckboxThemeData();

const appSwitchThemeData = SwitchThemeData();

const appSliderThemeData = SliderThemeData(
  // ignore: deprecated_member_use
  year2023: false,
  trackHeight: 12,
  thumbSize: WidgetStatePropertyAll(Size(5, 28)),
  overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0),
);

const appChipThemeData = ChipThemeData();

const dialogTheme = DialogThemeData(
  shape: RoundedRectangleBorder(borderRadius: AppStyles.borderRadius),
);

const navigationBarThemeData = NavigationBarThemeData(
  height: AppDimensions.navBarHeight,
);

const bottomSheetThemeData = BottomSheetThemeData(showDragHandle: true);

const proggressIndicatorThemeData = ProgressIndicatorThemeData(
  // ignore: deprecated_member_use
  year2023: false,
);

final ListTileThemeData listTileThemeData = ListTileThemeData(
  shape: const RoundedRectangleBorder(borderRadius: AppStyles.borderRadius),
  controlAffinity: !Device.isMobile ? ListTileControlAffinity.leading : null,
);
