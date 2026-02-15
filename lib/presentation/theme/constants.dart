import 'package:flutter/material.dart';

abstract class AppDimensions {
  static const double maxWidth = 1200;

  static const double navBarHeight = 68.0;
  static const double tabBarHeight = 40.0;
  static const double toolBarHeight = 60.0;
  static const double underElevation = 20.0;
  static const double toolBarHeightOnScroll = toolBarHeight - underElevation;

  static const double avatarHeight = 50.0;
  static const double avatarPublicationHeight = 30.0;
  static const double imageHeight = 200.0;

  static const double publicationBottomBarHeight = 36.0;
}

abstract class AppInsets {
  static const EdgeInsets screenPadding = .all(8.0);

  static const EdgeInsets cardMargin = .all(4.0);
  static const EdgeInsets cardPadding = .all(8.0);
  static const EdgeInsets tileContentPadding = .symmetric(horizontal: 8.0);

  static const EdgeInsets mostReadingDesktop = .fromLTRB(8, 8, 8, 8);
  static const EdgeInsets mostReadingMobile = .symmetric(
    horizontal: 4.0,
    vertical: 8.0,
  );

  static const EdgeInsets profileCardPadding = .symmetric(
    horizontal: 8.0,
    vertical: 16.0,
  );

  static const EdgeInsets filterSheetPadding = .fromLTRB(12, 0, 12, 24);
}

abstract class AppStyles {
  static const BorderRadius cardBorderRadius = BorderRadius.zero;

  static const BorderRadius dialogBorderRadius = BorderRadius.all(.circular(6));

  static const BorderRadius buttonBorderRadius = BorderRadius.all(.circular(3));

  static const BorderRadius checkboxBorderRadius = BorderRadius.all(
    .circular(2),
  );

  static const BorderRadius avatarBorderRadius = BorderRadius.all(.circular(3));
}

abstract class AppIcons {
  static const IconData hubPlaceholder = Icons.hub_rounded;
  static const IconData authorPlaceholder = Icons.account_box;
  static const IconData companyPlaceholder = Icons.schedule_rounded;
}
