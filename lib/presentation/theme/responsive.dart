part of 'theme.dart';

class ScreenType {
  static const String mobile = 'MOBILE';
  static const String tablet = 'TABLET';
  static const String desktop = 'DESKTOP';
}

class Device {
  bool get isMobile => Platform.isIOS || Platform.isAndroid;
  bool get isDesktop =>
      Platform.isMacOS || Platform.isWindows || Platform.isLinux;

  static double getHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}
