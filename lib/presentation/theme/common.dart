part of 'part.dart';

const appCardTheme = CardTheme(
  elevation: 1,
  surfaceTintColor: Colors.transparent,
  margin: EdgeInsets.all(fCardMargin),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(kBorderRadiusDefault)),
  ),
);

const AppBarTheme appAppBarTheme = AppBarTheme(
  surfaceTintColor: Colors.transparent,
  elevation: 0,
  scrolledUnderElevation: fScrolledUnderElevation,
  toolbarHeight: fToolBarHeight,
  titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
);

const PageTransitionsTheme appPageTransitionsTheme = PageTransitionsTheme(
  builders: {
    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
  },
);

ScrollbarThemeData appScrollBarThemeData = ScrollbarThemeData(
  thumbVisibility: WidgetStateProperty.all(false),
  interactive: true,
  thickness: WidgetStateProperty.all(6),
  minThumbLength: fToolBarHeightOnScroll,
);

TextButtonThemeData appTextButtonThemeData = TextButtonThemeData(
  style: TextButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(kBorderRadiusDefault),
    ),
  ),
);

const DrawerThemeData appDrawerThemeData = DrawerThemeData(width: 200);

const CheckboxThemeData appCheckboxThemeData = CheckboxThemeData();

const SwitchThemeData appSwitchThemeData = SwitchThemeData();

const SliderThemeData appSliderThemeData = SliderThemeData(
  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.0),
  overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0),
);

const ChipThemeData appChipThemeData = ChipThemeData(side: BorderSide.none);

const DialogTheme dialogTheme = DialogTheme(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(kBorderRadiusDefault)),
  ),
);

const NavigationBarThemeData navigationBarThemeData =
    NavigationBarThemeData(height: fNavBarHeight);
