part of 'theme.dart';

const appCardTheme = CardThemeData(
  elevation: 1,
  margin: AppInsets.cardMargin,
  shape: RoundedRectangleBorder(borderRadius: AppStyles.borderRadius),
);

const AppBarTheme appAppBarTheme = AppBarTheme(
  surfaceTintColor: Colors.transparent,
  elevation: 0,
  scrolledUnderElevation: AppDimensions.underElevation,
  toolbarHeight: AppDimensions.toolBarHeight,
  titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
);

const PageTransitionsTheme appPageTransitionsTheme = PageTransitionsTheme(
  builders: {
    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
    // не корректно работает, возможно проблема с auto_route
    // TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
  },
);

ScrollbarThemeData appScrollBarThemeData = ScrollbarThemeData(
  thumbVisibility: WidgetStateProperty.all(false),
  interactive: true,
  thickness: WidgetStateProperty.all(6),
  minThumbLength: AppDimensions.toolBarHeightOnScroll,
);

TextButtonThemeData appTextButtonThemeData = TextButtonThemeData(
  style: TextButton.styleFrom(
    shape: RoundedRectangleBorder(borderRadius: AppStyles.borderRadius),
  ),
);

IconButtonThemeData appIconButtonThemeData = IconButtonThemeData(
  style: IconButton.styleFrom(
    shape: RoundedRectangleBorder(borderRadius: AppStyles.borderRadius),
  ),
);

const DrawerThemeData appDrawerThemeData = DrawerThemeData(width: 200);

const CheckboxThemeData appCheckboxThemeData = CheckboxThemeData();

const SwitchThemeData appSwitchThemeData = SwitchThemeData();

const SliderThemeData appSliderThemeData = SliderThemeData(
  // ignore: deprecated_member_use
  year2023: false,
  trackHeight: 12,
  thumbSize: WidgetStatePropertyAll(Size(5, 28)),
  overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0),
);

const ChipThemeData appChipThemeData = ChipThemeData();

const DialogTheme dialogTheme = DialogTheme(
  shape: RoundedRectangleBorder(borderRadius: AppStyles.borderRadius),
);

const NavigationBarThemeData navigationBarThemeData = NavigationBarThemeData(
  height: AppDimensions.navBarHeight,
);

const BottomSheetThemeData bottomSheetThemeData = BottomSheetThemeData(
  showDragHandle: true,
);

const ProgressIndicatorThemeData proggressIndicatorThemeData =
// ignore: deprecated_member_use
ProgressIndicatorThemeData(year2023: false);
