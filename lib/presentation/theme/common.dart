// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter/material.dart';

import 'constants.dart';
import 'responsive.dart';

const appCardTheme = CardThemeData(
  elevation: 1,
  margin: AppInsets.cardMargin,
  shape: LinearBorder(),
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
    shape: const RoundedRectangleBorder(
      borderRadius: AppStyles.buttonBorderRadius,
    ),
  ),
);

final appIconButtonThemeData = IconButtonThemeData(
  style: IconButton.styleFrom(
    shape: const RoundedRectangleBorder(
      borderRadius: AppStyles.buttonBorderRadius,
    ),
  ),
);

final appFilledButtonStyle = FilledButton.styleFrom(
  shape: const RoundedRectangleBorder(
    borderRadius: AppStyles.buttonBorderRadius,
  ),
);

final appOutlinedButtonStyle = OutlinedButton.styleFrom(
  shape: const RoundedRectangleBorder(
    borderRadius: AppStyles.buttonBorderRadius,
  ),
);

final appElevatedButtonStyle = ElevatedButton.styleFrom(
  shape: const RoundedRectangleBorder(
    borderRadius: AppStyles.buttonBorderRadius,
  ),
);

const appDrawerThemeData = DrawerThemeData(width: 200);

final ListTileThemeData listTileThemeData = ListTileThemeData(
  shape: const LinearBorder(),
  visualDensity: VisualDensity.compact,
  minVerticalPadding: 0,
  contentPadding: AppInsets.tileContentPadding,
  controlAffinity: !Device.isMobile ? ListTileControlAffinity.leading : null,
);

const appCheckboxThemeData = CheckboxThemeData(
  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  visualDensity: VisualDensity.compact,
  shape: RoundedRectangleBorder(borderRadius: AppStyles.checkboxBorderRadius),
);

const appSwitchThemeData = SwitchThemeData(
  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  padding: EdgeInsets.zero,
);

const appSliderThemeData = SliderThemeData(
  // ignore: deprecated_member_use
  year2023: false,
  trackHeight: 12,
  thumbSize: WidgetStatePropertyAll(Size(5, 28)),
  overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0),
);

const appChipThemeData = ChipThemeData(
  shape: RoundedRectangleBorder(borderRadius: AppStyles.buttonBorderRadius),
);

const dialogTheme = DialogThemeData(
  shape: RoundedRectangleBorder(borderRadius: AppStyles.dialogBorderRadius),
);

const navigationBarThemeData = NavigationBarThemeData(
  height: AppDimensions.navBarHeight,
);

const bottomSheetThemeData = BottomSheetThemeData(showDragHandle: true);

const proggressIndicatorThemeData = ProgressIndicatorThemeData(
  // ignore: deprecated_member_use
  year2023: false,
);
