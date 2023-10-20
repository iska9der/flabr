import 'package:flutter/material.dart';

import '../../config/constants.dart';
import '../widget/enhancement/progress_indicator.dart';

mixin ImageUtilsMixin {
  Widget onImageLoading(BuildContext context, String url) => const SizedBox(
        height: kImageHeightDefault,
        child: CircleIndicator.small(),
      );

  Widget onImageError(BuildContext context, String url, error) =>
      const SizedBox(
        height: kImageHeightDefault,
        child: Icon(
          Icons.image_not_supported_outlined,
          color: Colors.red,
        ),
      );
}
