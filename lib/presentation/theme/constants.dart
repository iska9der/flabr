import 'package:flutter/material.dart';

abstract class AppDimensions {
  static const double maxWidth = 1200;

  static const double navBarHeight = 68.0;
  static const double tabBarHeight = 40.0;
  static const double toolBarHeight = 60.0;
  static const double underElevation = 20.0;
  static const double toolBarHeightOnScroll = toolBarHeight - underElevation;

  static const double cardBetweenHeight = 16.0;

  static const double avatarHeight = 50.0;
  static const double avatarPublicationHeight = 30.0;
  static const double imageHeight = 200.0;

  static const double publicationBottomBarHeight = 36.0;
}

abstract class AppInsets {
  static const EdgeInsets screenPadding = EdgeInsets.all(8.0);

  static const EdgeInsets cardMargin = EdgeInsets.all(4.0);
  static const EdgeInsets cardPadding = EdgeInsets.all(8.0);

  static const EdgeInsets mostReadingDesktop = EdgeInsets.fromLTRB(8, 8, 8, 8);
  static const EdgeInsets mostReadingMobile = EdgeInsets.symmetric(
    horizontal: 4.0,
    vertical: 8.0,
  );

  static const EdgeInsets profileCardPadding = EdgeInsets.symmetric(
    horizontal: 8.0,
    vertical: 16.0,
  );

  static const EdgeInsets filterSheetPadding = EdgeInsets.fromLTRB(
    12,
    0,
    12,
    24,
  );
}

abstract class AppStyles {
  static const BorderRadius borderRadius = BorderRadius.all(
    Radius.circular(8.0),
  );

  static const BorderRadius borderRadiusSm = BorderRadius.all(
    Radius.circular(4.0),
  );
}

abstract class AppIcons {
  static const IconData hubPlaceholder = Icons.hub_rounded;
  static const IconData authorPlaceholder = Icons.account_circle;
  static const IconData companyPlaceholder = Icons.schedule_rounded;
}
