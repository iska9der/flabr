import 'package:injectable/injectable.dart';

import 'image_utils_mixin.dart';

export 'image_utils_mixin.dart';

@Singleton()
class Utils with ImageUtilsMixin {
  const Utils();
}
