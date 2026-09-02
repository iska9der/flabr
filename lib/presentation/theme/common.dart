// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'constants.dart';
import 'responsive.dart';

const appCardThemeData = CardThemeData(
  elevation: 1,
  margin: AppInsets.sm,
  shape: RoundedRectangleBorder(borderRadius: AppRadius.zero),
);

const appAppBarThemeData = AppBarThemeData(
  surfaceTintColor: Colors.transparent,
  elevation: 0,
  scrolledUnderElevation: AppDimensions.underElevation,
  toolbarHeight: AppDimensions.toolBarHeight,
);

const appPageTransitionsTheme = PageTransitionsTheme(
  builders: {
    .iOS: CupertinoPageTransitionsBuilder(),
    .android: FadeUpwardsPageTransitionsBuilder(),
    // не корректно работает, возможно проблема с auto_route
    // TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
  },
);

final appScrollBarThemeData = ScrollbarThemeData(
  thumbVisibility: .all(false),
  interactive: true,
  thickness: .all(6),
  minThumbLength: AppDimensions.toolBarHeightOnScroll,
);

final inputDecorationThemeData = const InputDecorationThemeData(
  border: OutlineInputBorder(
    borderRadius: AppRadius.xl,
    borderSide: .new(width: 1),
  ),
);

final appTextButtonThemeData = TextButtonThemeData(
  style: TextButton.styleFrom(
    shape: const RoundedRectangleBorder(
      borderRadius: AppRadius.sm,
    ),
  ),
);

final appIconButtonThemeData = IconButton.styleFrom(
  shape: const RoundedRectangleBorder(
    borderRadius: AppRadius.sm,
  ),
);

final appFilledButtonStyle = FilledButton.styleFrom(
  shape: const RoundedRectangleBorder(
    borderRadius: AppRadius.sm,
  ),
);

final appOutlinedButtonStyle = OutlinedButton.styleFrom(
  shape: const RoundedRectangleBorder(
    borderRadius: AppRadius.sm,
  ),
);

final appElevatedButtonStyle = ElevatedButton.styleFrom(
  shape: const RoundedRectangleBorder(
    borderRadius: AppRadius.sm,
  ),
);

const appDrawerThemeData = DrawerThemeData(width: 200);

final ListTileThemeData listTileThemeData = ListTileThemeData(
  shape: const LinearBorder(),
  visualDensity: .compact,
  minVerticalPadding: 0,
  contentPadding: AppInsets.listTile,
  controlAffinity: !Device.isMobile ? .leading : null,
);

const appCheckboxThemeData = CheckboxThemeData(
  visualDensity: .compact,
  shape: RoundedRectangleBorder(borderRadius: AppRadius.xs),
);

const appSwitchThemeData = SwitchThemeData(
  padding: .zero,
);

const appSliderThemeData = SliderThemeData(
  // ignore: deprecated_member_use
  year2023: false,
  trackHeight: 12,
  thumbSize: WidgetStatePropertyAll(Size(5, 28)),
  overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0),
);

const appChipThemeData = ChipThemeData(
  shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
);

const dialogThemeData = DialogThemeData(
  shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
);

const navigationBarThemeData = NavigationBarThemeData(
  height: AppDimensions.navBarHeight,
);

const bottomSheetThemeData = BottomSheetThemeData(showDragHandle: true);

const proggressIndicatorThemeData = ProgressIndicatorThemeData(
  // ignore: deprecated_member_use
  year2023: false,
);
