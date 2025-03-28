import 'package:flutter/material.dart';

abstract class AppDimensions {
  static const double maxWidth = 1200;

  static const double borderRadius = 8.0;

  static const double screenPadding = 8.0;

  static const double navBarHeight = 68.0;
  static const double dashTabHeight = 40.0;
  static const double toolBarHeight = 60.0;
  static const double underElevation = 20.0;
  static const double toolBarHeightOnScroll = toolBarHeight - underElevation;

  static const double cardMargin = 4.0;
  static const double cardPadding = 8.0;
  static const double cardBetweenHeight = 16.0;

  static const double avatarHeight = 50.0;
  static const double avatarPublicationHeight = 30.0;
  static const double imageHeight = 200.0;

  static const double publicationBottomBarHeight = 36.0;
}

abstract class AppInsets {
  static const EdgeInsets screenPadding = EdgeInsets.all(
    AppDimensions.screenPadding,
  );

  static const EdgeInsets cardMargin = EdgeInsets.all(AppDimensions.cardMargin);
  static const EdgeInsets cardPadding = EdgeInsets.all(
    AppDimensions.cardPadding,
  );

  static const EdgeInsets mostReadingDesktop = EdgeInsets.fromLTRB(8, 8, 8, 8);
  static const EdgeInsets mostReadingMobile = EdgeInsets.symmetric(
    horizontal: AppDimensions.cardMargin,
    vertical: AppDimensions.cardBetweenHeight / 2,
  );

  static const EdgeInsets profileCardPadding = EdgeInsets.symmetric(
    horizontal: AppDimensions.screenPadding,
    vertical: AppDimensions.screenPadding * 2,
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
    Radius.circular(AppDimensions.borderRadius),
  );
}
