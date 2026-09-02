import 'package:flutter/material.dart';

abstract class AppDimensions {
  static const double maxWidth = 1200;

  static const double navBarHeight = 60.0;
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
  static const EdgeInsets screen = .all(0);

  /// Чтобы боттомбар под ногами не мешался
  static final EdgeInsets screenExtended = screen.copyWith(bottom: 128);

  static const EdgeInsets sm = .all(4.0);
  static const EdgeInsets md = .all(8.0);

  static const EdgeInsets listTile = .symmetric(horizontal: 8.0);
  static const EdgeInsets mostReadingDesktop = .fromLTRB(8, 8, 8, 8);
  static const EdgeInsets mostReadingMobile = .fromLTRB(4, 8, 4, 8);
  static const EdgeInsets profileCard = .fromLTRB(8, 16, 8, 16);
  static const EdgeInsets filterSheet = .fromLTRB(12, 0, 12, 24);
}

abstract class AppRadius {
  static const BorderRadius zero = .zero;
  static const BorderRadius xs = .all(.circular(3));
  static const BorderRadius sm = .all(.circular(6));
  static const BorderRadius md = .all(.circular(12));
  static const BorderRadius xl = .all(.circular(16));
  static const BorderRadius xxl = .all(.circular(24));
}

abstract class AppDuration {
  static const Duration hide = .new(milliseconds: 180);
}

abstract class AppIcons {
  static const IconData hubPlaceholder = Icons.hub_rounded;
  static const IconData authorPlaceholder = Icons.account_box;
  static const IconData companyPlaceholder = Icons.schedule_rounded;

  static const IconData chevronRight = Icons.chevron_right_rounded;
}
