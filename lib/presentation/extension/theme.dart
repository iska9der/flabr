import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';

extension ThemeX on ThemeData {
  AppColorsExtension get colors => extension<AppColorsExtension>()!;

  UserTypographyExtension get appTypography =>
      extension<UserTypographyExtension>()!;
}
