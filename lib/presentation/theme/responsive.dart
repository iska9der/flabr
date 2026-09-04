import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ScreenType {
  static const String mobile = 'MOBILE';
  static const String tablet = 'TABLET';
  static const String desktop = 'DESKTOP';
}

class Device {
  static bool get isMobile => !kIsWeb && (Platform.isIOS || Platform.isAndroid);
  static bool get isDesktop =>
      Platform.isMacOS || Platform.isWindows || Platform.isLinux;

  static double getHeight(BuildContext context, {bool safe = false}) {
    double height = MediaQuery.sizeOf(context).height;

    if (safe) {
      final viewPadding = MediaQuery.viewPaddingOf(context);
      height -= (viewPadding.top + viewPadding.bottom);
    }

    return height;
  }

  static double getWidth(BuildContext context) {
    return MediaQuery.sizeOf(context).width;
  }
}
