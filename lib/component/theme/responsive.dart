import 'dart:io';

class ScreenType {
  static const String mobile = 'MOBILE';
  static const String tablet = 'TABLET';
  static const String desktop = 'DESKTOP';
}

class Device {
  bool get isMobile => Platform.isIOS || Platform.isAndroid;
  bool get isDesktop =>
      Platform.isMacOS || Platform.isWindows || Platform.isLinux;
}
