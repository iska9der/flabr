import 'package:flutter/material.dart';

import '../theme/theme.dart';

extension ThemeX on ThemeData {
  AppColors get colors => extension<AppColors>()!;
}
