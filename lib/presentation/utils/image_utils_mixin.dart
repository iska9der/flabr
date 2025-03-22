import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../theme/theme.dart';

mixin ImageUtilsMixin {
  Widget onImageLoading(BuildContext context, String url) => const SizedBox(
    height: AppDimensions.imageHeight,
    child: Skeletonizer(child: ColoredBox(color: Colors.white)),
  );

  Widget onImageError(BuildContext context, String url, error) =>
      const SizedBox(
        height: AppDimensions.imageHeight,
        child: Icon(Icons.image_not_supported_outlined, color: Colors.red),
      );
}
