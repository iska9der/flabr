import 'package:flutter/material.dart';

import '../theme/theme.dart';

extension AppThemeExtension on ThemeData {
  AppColorsExtension get colors => extension<AppColorsExtension>()!;
}
