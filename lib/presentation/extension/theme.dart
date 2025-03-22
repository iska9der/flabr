import 'package:flutter/material.dart';

import '../theme/theme.dart';

extension ThemeX on ThemeData {
  AppColorsExtension get colors => extension<AppColorsExtension>()!;
}
